import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String? accessToken;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String? avatar;
  final String? position;
  final String? company;
  final String? address;
  final String? website;
  final String? linkedIn;
  final String? cardUrl;
  final String? bio;

  const UserEntity({
    required this.id,
    this.accessToken,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.avatar,
    this.position,
    this.company,
    this.address,
    this.website,
    this.linkedIn,
    this.cardUrl,
    this.bio,
  });

  UserEntity copyWith({
    int? id,
    String? accessToken,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? avatar,
    String? position,
    String? company,
    String? address,
    String? website,
    String? linkedIn,
    String? cardUrl,
    String? bio,
  }) => UserEntity(
    id: id ?? this.id,
    accessToken: accessToken ?? this.accessToken,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    password: password ?? this.password,
    avatar: avatar ?? this.avatar,
    position: position ?? this.position,
    company: company ?? this.company,
    address: address ?? this.address,
    website: website ?? this.website,
    linkedIn: linkedIn ?? this.linkedIn,
    cardUrl: cardUrl ?? this.cardUrl,
    bio: bio ?? this.bio,
  );

  @override
  List<Object?> get props => [
    id,
    accessToken,
    name,
    email,
    phone,
    password,
    avatar,
    position,
    company,
    address,
    website,
    linkedIn,
    cardUrl,
    bio,
  ];
}
