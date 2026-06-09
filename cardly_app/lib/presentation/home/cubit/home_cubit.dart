import 'package:cardly_app/domain/usecase/contact/get_contacts_usecase.dart';
import 'package:cardly_app/presentation/home/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetContactsUsecase getContactsUsecase;

  HomeCubit({required this.getContactsUsecase}) : super(const HomeState());

  Future<void> loadContacts() async {
    emit(state.copyWith(contactsStatus: ContactsStatus.loading));
    final result = await getContactsUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          contactsStatus: ContactsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (contacts) => emit(
        state.copyWith(
          contacts: contacts,
          contactsStatus: ContactsStatus.loaded,
        ),
      ),
    );
  }
}
