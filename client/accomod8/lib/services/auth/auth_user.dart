import 'package:flutter/foundation.dart' show immutable;

//  User
@immutable
class AuthUser {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;

  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });
}
