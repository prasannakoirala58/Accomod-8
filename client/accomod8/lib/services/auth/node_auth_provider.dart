import 'dart:convert';
import 'package:accomod8/config.dart';
import 'package:accomod8/services/auth/auth_provider.dart';
import 'package:accomod8/services/auth/auth_user.dart';
import 'package:http/http.dart' as http;

import 'auth_exceptions.dart';

class NodeAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String username,
    required String password,
    required String matchingPassword,
    required String userType,
  }) async {
    if (matchingPassword != password) {
      throw PasswordDoesNotMatchAuthException;
    }
    var registerUserBody = {
      'username': username,
      'email': email,
      'password': password,
      "typeof_user": userType,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
    };

    var response = await http.post(
      Uri.parse(registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registerUserBody),
    );

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse);

    final user = currentUser;
    if (user != null) {
      print('response');
      return user;
    } else {
      print('cringe');
      throw 'a';
    }
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => throw UnimplementedError();

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> logIn({
    required String username,
    required String password,
  }) async {
    var loginUserBody = {
      "username": username,
      "password": password,
    };
    var response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginUserBody),
    );

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse);

    final user = currentUser;
    if (user != null) {
      print('response');
      return user;
    } else {
      print('cringe');
      throw 'a';
    }
  }
}
