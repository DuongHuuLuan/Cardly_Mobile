import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:equatable/equatable.dart';

enum ContactStatus {
  initial,
  loading,
  loaded,
  saving,
  enriching,
  deleting,
  failure,
}

class ContactState extends Equatable {
  final ContactStatus status;
  final List<BusinessCardEntity> contacts;
  final String? errorMessage;
  final bool hasMore;
  final bool isLoadingMore;
  final int currentPage;

  const ContactState({
    this.status = ContactStatus.initial,
    this.contacts = const [],
    this.errorMessage,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.currentPage = 0,
  });

  ContactState copyWith({
    ContactStatus? status,
    List<BusinessCardEntity>? contacts,
    String? errorMessage,
    bool? hasMore,
    bool? isLoadingMore,
    int? currentPage,
  }) => ContactState(
    status: status ?? this.status,
    contacts: contacts ?? this.contacts,
    errorMessage: errorMessage ?? this.errorMessage,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    currentPage: currentPage ?? this.currentPage,
  );

  @override
  List<Object?> get props => [
    status,
    contacts,
    errorMessage,
    hasMore,
    isLoadingMore,
    currentPage,
  ];
}
