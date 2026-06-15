import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/domain/entities/enrichment/enrichment_entity.dart';
import 'package:cardly_app/domain/usecase/contact/delete_contact_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/get_contact_by_id_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/get_contacts_paginated_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/get_contacts_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/save_contact_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/sync_contacts_usecase.dart';
import 'package:cardly_app/domain/usecase/enrichment/enrichment_usecase.dart';
import 'package:cardly_app/injection_container.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactCubit extends Cubit<ContactState> {
  static const int _pageSize = 8;
  final GetContactsUsecase getContacts;
  final GetContactByIdUsecase getcontactById;
  final SaveContactUsecase saveContact;
  final DeleteContactUsecase deleteContact;
  final EnrichmentUsecase enrichment;
  final SyncContactsUsecase syncContacts;
  final GetContactsPaginatedUsecase getContactsPaginated;

  ContactCubit({
    required this.getContacts,
    required this.getcontactById,
    required this.saveContact,
    required this.deleteContact,
    required this.enrichment,
    required this.syncContacts,
    required this.getContactsPaginated,
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

    final result = await getContactsPaginated(0, 8);
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

  Future<void> loadContactDetail(String id) async {
    emit(
      state.copyWith(
        status: ContactStatus.loading,
        isEditing: false,
        clearError: true,
      ),
    );

    final localContact = state.contacts.where((e) => e.id == id).firstOrNull;

    if (localContact != null) {
      emit(
        state.copyWith(
          status: ContactStatus.loaded,
          selectedContact: localContact,
          avatar: localContact.avatar,
        ),
      );
      return;
    }

    final result = await getcontactById(id);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ContactStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (contact) {
        emit(
          state.copyWith(
            status: ContactStatus.loaded,
            selectedContact: contact,
            avatar: contact.avatar,
          ),
        );
      },
    );
  }

  void startEdit() {
    emit(state.copyWith(isEditing: true));
  }

  void cancelEdit() {
    final contact = state.selectedContact;
    emit(state.copyWith(isEditing: false, avatar: contact?.avatar));
  }

  void toggleEdit() {
    if (state.isEditing) {
      cancelEdit();
    } else {
      startEdit();
    }
  }

  void updateDraftAvatar(String path) {
    emit(state.copyWith(avatar: path));
  }

  Future<BusinessCardEntity?> saveEntity(BusinessCardEntity contact) async {
    emit(state.copyWith(status: ContactStatus.saving, clearError: true));
    final result = await saveContact(contact);
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
      (saved) {
        final updated = state.contacts
            .map((e) => e.id == saved.id ? saved : e)
            .toList();
        final exists = updated.any((e) => e.id == saved.id);
        emit(
          state.copyWith(
            status: ContactStatus.loaded,
            contacts: exists ? updated : [saved, ...updated],
            selectedContact: saved,
            isEditing: false,
          ),
        );
        return saved;
      },
    );
  }

  Future<BusinessCardEntity?> saveSelectedContact({
    required String fullName,
    required String jobTitle,
    required String company,
    required String phone,
    required String email,
    required String website,
    required String linkedIn,
    required String address,
    required String notes,
  }) async {
    final contact = state.selectedContact;
    if (contact == null) return null;

    emit(state.copyWith(status: ContactStatus.saving, clearError: true));

    final updatedContact = contact.copyWith(
      avatar: state.avatar,
      fullName: fullName.trim(),
      jobTitle: jobTitle.trim(),
      company: company.trim(),
      phone: phone.trim(),
      email: email.trim(),
      website: website.trim(),
      linkedIn: linkedIn.trim(),
      address: address.trim(),
      notes: notes.trim(),
    );

    final result = await saveContact(updatedContact);

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
      (saved) {
        final updatedContacts = state.contacts.map((e) {
          return e.id == saved.id ? saved : e;
        }).toList();

        final exists = updatedContacts.any((e) => e.id == saved.id);
        final finalContacts = exists
            ? updatedContacts
            : [saved, ...updatedContacts];

        emit(
          state.copyWith(
            status: ContactStatus.loaded,
            contacts: finalContacts,
            selectedContact: saved,
            avatar: saved.avatar,
            isEditing: false,
          ),
        );

        return saved;
      },
    );
  }

  Future<bool> deleteSelectedContact() async {
    final contact = state.selectedContact;
    if (contact?.id == null) return false;

    emit(state.copyWith(status: ContactStatus.deleting, clearError: true));

    final result = await deleteContact(contact!.id!);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ContactStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (_) {
        final updated = state.contacts
            .where((element) => element.id != contact.id)
            .toList();

        emit(
          state.copyWith(
            status: ContactStatus.loaded,
            contacts: updated,
            clearSelectedContact: true,
            isEditing: false,
          ),
        );

        return true;
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final offset = nextPage * _pageSize;

    final result = await getContactsPaginated(offset, _pageSize);

    result.fold(
      (_) {
        emit(state.copyWith(isLoadingMore: false));
      },
      (paginated) {
        emit(
          state.copyWith(
            contacts: [...state.contacts, ...paginated.items],
            hasMore: paginated.hasMore,
            currentPage: nextPage,
            isLoadingMore: false,
          ),
        );
      },
    );
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

  void applyEnrichment(
    String? brief,
    List<String>? keywords,
    List<String>? highlights,
  ) {
    emit(
      state.copyWith(brief: brief, keywords: keywords, highlights: highlights),
    );
  }

  Future<BusinessCardEntity?> saveWithEnrichment(
    BusinessCardEntity card,
    EnrichmentEntity enrichment,
  ) async {
    final updated = card.copyWith(
      brief: enrichment.professionalBrief,
      keywords: enrichment.keywords,
      highlights: enrichment.highlights,
      avatar: card.avatar,
    );
    return saveEntity(updated);
  }

  void enrichComplete() {
    emit(state.copyWith(status: ContactStatus.loaded));
  }
}
