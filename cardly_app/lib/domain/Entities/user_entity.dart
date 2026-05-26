import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String? accessToken;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String? avatar;

  const UserEntity({
    required this.id,
    this.accessToken,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.avatar,
  });

  @override
  List<Object?> get props => [
    id,
    accessToken,
    name,
    email,
    phone,
    password,
    avatar,
  ];
}
