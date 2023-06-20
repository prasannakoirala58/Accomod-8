import 'package:accomod8/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String fullName,
    required String email,
    // required String phoneNumber,
    required String password,
    // required String matchingPassword,
  });
}
