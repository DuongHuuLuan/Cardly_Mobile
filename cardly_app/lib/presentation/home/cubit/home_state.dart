import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

enum ContactsStatus { initial, loading, loaded, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final String? errorMessage;
  final List<BusinessCardEntity> contacts;
  final ContactsStatus contactsStatus;

  const HomeState({
    this.status = HomeStatus.initial,
    this.errorMessage,
    this.contacts = const [],
    this.contactsStatus = ContactsStatus.initial,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    List<BusinessCardEntity>? contacts,
    ContactsStatus? contactsStatus,
  }) => HomeState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    contacts: contacts ?? this.contacts,
    contactsStatus: contactsStatus ?? this.contactsStatus,
  );

  @override
  List<Object?> get props => [status, errorMessage, contacts, contactsStatus];
}
