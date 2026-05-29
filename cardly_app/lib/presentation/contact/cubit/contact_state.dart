import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:equatable/equatable.dart';

enum ContactStatus { initial, loading, loaded, saving, deleting, failure }

class ContactState extends Equatable {
  final ContactStatus status;
  final List<BusinessCardEntity> contacts;
  final String? errorMessage;

  const ContactState({
    this.status = ContactStatus.initial,
    this.contacts = const [],
    this.errorMessage,
  });

  ContactState copyWith({
    ContactStatus? status,
    List<BusinessCardEntity>? contacts,
    String? errorMessage,
  }) => ContactState(
    status: status ?? this.status,
    contacts: contacts ?? this.contacts,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, contacts, errorMessage];
}
