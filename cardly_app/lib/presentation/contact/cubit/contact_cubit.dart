import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:cardly_app/domain/usecase/contact/delete_contact_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/get_contacts_usecase.dart';
import 'package:cardly_app/domain/usecase/contact/save_contact_usecase.dart';
import 'package:cardly_app/presentation/contact/cubit/contact_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactCubit extends Cubit<ContactState> {
  final GetContactsUsecase getContacts;
  final SaveContactUsecase saveContact;
  final DeleteContactUsecase deleteContact;

  ContactCubit({
    required this.getContacts,
    required this.saveContact,
    required this.deleteContact,
  }) : super(const ContactState());

  Future<void> loadContacts() async {
    emit(state.copyWith(status: ContactStatus.loading));
    final result = await getContacts();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ContactStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (contacts) {
        emit(state.copyWith(status: ContactStatus.loaded, contacts: contacts));
      },
    );
  }

  Future<BusinessCardEntity?> save(BusinessCardEntity contact) async {
    emit(state.copyWith(status: ContactStatus.saving));

    final result = await saveContact(contact);

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
        final updated = [saved, ...state.contacts];
        emit(state.copyWith(status: ContactStatus.loaded, contacts: updated));
        return saved;
      },
    );
    return null;
  }

  Future<bool> delete(String id) async {
    emit(state.copyWith(status: ContactStatus.deleting));

    final result = await deleteContact(id);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ContactStatus.failure,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (r) {
        final updated = state.contacts
            .where((element) => element.id != id)
            .toList();
        emit(state.copyWith(status: ContactStatus.loaded, contacts: updated));
      },
    );
    return true;
  }

  void enrich() {
    emit(state.copyWith(status: ContactStatus.enriching));
  }

  void enrichComplete() {
    emit(state.copyWith(status: ContactStatus.loaded));
  }
}
