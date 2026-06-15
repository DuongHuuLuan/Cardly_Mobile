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
  final BusinessCardEntity? selectedContact;
  final String? avatar;
  final bool isEditing;
  final String? brief;
  final List<String>? keywords;
  final List<String>? highlights;

  final String? errorMessage;
  final bool hasMore;
  final bool isLoadingMore;
  final int currentPage;

  const ContactState({
    this.status = ContactStatus.initial,
    this.contacts = const [],
    this.selectedContact,
    this.avatar,
    this.brief,
    this.keywords,
    this.highlights,
    this.isEditing = false,
    this.errorMessage,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.currentPage = 0,
  });

  ContactState copyWith({
    ContactStatus? status,
    List<BusinessCardEntity>? contacts,
    BusinessCardEntity? selectedContact,
    String? avatar,
    String? brief,
    List<String>? keywords,
    List<String>? highlights,
    bool? isEditing,
    String? errorMessage,
    bool? hasMore,
    bool? isLoadingMore,
    int? currentPage,
    bool clearError = false,
    bool clearSelectedContact = false,
  }) => ContactState(
    status: status ?? this.status,
    contacts: contacts ?? this.contacts,
    selectedContact: clearSelectedContact
        ? null
        : selectedContact ?? this.selectedContact,
    avatar: avatar ?? this.avatar,
    brief: brief ?? this.brief,
    keywords: keywords ?? this.keywords,
    highlights: highlights ?? this.highlights,
    isEditing: isEditing ?? this.isEditing,
    errorMessage: errorMessage ?? this.errorMessage,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    currentPage: currentPage ?? this.currentPage,
  );

  @override
  List<Object?> get props => [
    status,
    contacts,
    selectedContact,
    avatar,
    brief,
    keywords,
    highlights,
    isEditing,
    errorMessage,
    hasMore,
    isLoadingMore,
    currentPage,
  ];
}
