import 'package:cardly_app/core/cubit/app_loading_cubit.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/domain/entities/enrichment/enrichment_entity.dart';
import 'package:cardly_app/domain/repositories/contact_repository.dart';
import 'package:cardly_app/domain/usecase/contact/delete_contact_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/get_contacts_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/save_contact_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/sync_contacts_usecase.dart';
import 'package:cardly_app/domain/usecase/enrichment/enrichment_usecase.dart';
import 'package:cardly_app/injection_container.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactCubit extends Cubit<ContactState> {
  final GetContactsUsecase getContacts;
  final SaveContactUsecase saveContact;
  final DeleteContactUsecase deleteContact;
  final EnrichmentUsecase enrichment;
  final SyncContactsUsecase syncContacts;
  final ContactRepository contactRepository;

  ContactCubit({
    required this.getContacts,
    required this.saveContact,
    required this.deleteContact,
    required this.enrichment,
    required this.syncContacts,
    required this.contactRepository,
  }) : super(const ContactState());

  Future<void> loadContacts({bool refresh = false}) async {
    emit(
      state.copyWith(
        status: ContactStatus.loading,
        hasMore: true,
        currentPage: 0,
      ),
    );

    await syncContacts();

    final prefs = getIt<SharedPreferences>();
    if (prefs.getBool('session_expired') == true) {
      emit(
        state.copyWith(
          status: ContactStatus.failure,
          errorMessage: "The login session has expired.",
        ),
      );
      return;
    }

    final result = await contactRepository.getContactsPaginated(0, 8);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ContactStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (paginated) {
        emit(
          state.copyWith(
            status: ContactStatus.loaded,
            contacts: paginated.items,
            hasMore: paginated.hasMore,
            currentPage: 0,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;
    final result = await contactRepository.getContactsPaginated(
      nextPage * 20,
      20,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (paginated) => emit(
        state.copyWith(
          contacts: [...state.contacts, ...paginated.items],
          hasMore: paginated.hasMore,
          currentPage: nextPage,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<BusinessCardEntity?> save(BusinessCardEntity contact) async {
    emit(state.copyWith(status: ContactStatus.saving));

    final result = await saveContact(contact);
    BusinessCardEntity? savedEntity;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ContactStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (saved) {
        savedEntity = saved;
        final updated = [saved, ...state.contacts];
        emit(state.copyWith(status: ContactStatus.loaded, contacts: updated));
      },
    );
    return savedEntity;
  }

  Future<bool> delete(BusinessCardEntity contact) async {
    emit(state.copyWith(status: ContactStatus.deleting));

    final result = await deleteContact(contact.id!);
    bool success = false;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ContactStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (r) {
        success = true;
        final updated = state.contacts
            .where((element) => element.id != contact.id)
            .toList();
        emit(state.copyWith(status: ContactStatus.loaded, contacts: updated));
      },
    );
    getIt<AppLoadingCubit>().hide();
    return success;
  }

  Future<EnrichmentEntity?> enrich(Map<String, dynamic> data) async {
    emit(state.copyWith(status: ContactStatus.enriching));
    final result = await enrichment.enrich(data);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ContactStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return null;
      },
      (enriched) {
        emit(state.copyWith(status: ContactStatus.loaded));
        return enriched;
      },
    );
  }

  void enrichComplete() {
    emit(state.copyWith(status: ContactStatus.loaded));
  }
}
