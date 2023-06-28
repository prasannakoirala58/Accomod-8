// import 'package:accomod8/services/auth/auth_user.dart';

import 'dart:io';

abstract class AuthProvider {
  Future<void> initialize();

  // AuthUser? get currentUser;

  // Future<AuthUser> logIn({
  //   required String username,
  //   required String password,
  // });

  // Future<AuthUser> createUser({
  //   required String firstName,
  //   required String lastName,
  //   required String email,
  //   required String gender,
  //   required String username,
  //   required String password,
  //   required String matchingPassword,
  //   required String userType,
  // });

  Future<String> logIn({
    required String email,
    required String password,
  });

  Future<String> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String username,
    required String password,
    required String matchingPassword,
    required String userType,
    required File image,
    required File document,
  });

  Future<String> logOut();
}
