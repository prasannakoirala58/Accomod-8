import 'package:flutter/foundation.dart' show immutable;

//  User
@immutable
class AuthUser {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String email;
  final String username;
  final String userType;

  const AuthUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.username,
    required this.userType,
  });
}
