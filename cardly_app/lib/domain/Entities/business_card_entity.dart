import 'package:equatable/equatable.dart';

class BusinessCardEntity extends Equatable {
  final String? id;
  final String? fullName;
  final String? jobTitle;
  final String? company;
  final String? phone;
  final String? email;
  final String? website;
  final String? linkedIn;
  final String? facebook;
  final String? address;
  final String? qrCodeContent;
  final String? notes;
  final String? eventName;
  final String? location;
  final DateTime? createdAt;
  final String? brief;
  final List<String>? keywords;
  final List<String>? highlights;
  final List<String>? images;

  const BusinessCardEntity({
    this.id,
    this.fullName,
    this.jobTitle,
    this.company,
    this.phone,
    this.email,
    this.website,
    this.linkedIn,
    this.facebook,
    this.address,
    this.qrCodeContent,
    this.notes,
    this.eventName,
    this.location,
    this.createdAt,
    this.brief,
    this.keywords,
    this.highlights,
    this.images,
  });

  BusinessCardEntity copyWith({
    String? id,
    String? fullName,
    String? jobTitle,
    String? company,
    String? phone,
    String? email,
    String? website,
    String? linkedIn,
    String? facebook,
    String? address,
    String? qrCodeContent,
    String? notes,
    String? eventName,
    String? location,
    DateTime? createdAt,
    String? brief,
    List<String>? keywords,
    List<String>? highlights,
    List<String>? images,
  }) {
    return BusinessCardEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      linkedIn: linkedIn ?? this.linkedIn,
      facebook: facebook ?? this.facebook,
      address: address ?? this.address,
      qrCodeContent: qrCodeContent ?? this.qrCodeContent,
      notes: notes ?? this.notes,
      eventName: eventName ?? this.eventName,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      brief: brief ?? this.brief,
      keywords: keywords ?? this.keywords,
      highlights: highlights ?? this.highlights,
      images: images ?? this.images,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    jobTitle,
    company,
    phone,
    email,
    website,
    linkedIn,
    facebook,
    address,
    qrCodeContent,
    notes,
    eventName,
    location,
    createdAt,
    brief,
    keywords,
    highlights,
    images,
  ];
}
