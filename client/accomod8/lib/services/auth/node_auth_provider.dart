import 'dart:convert';
import 'package:accomod8/config.dart';
import 'package:accomod8/services/auth/auth_provider.dart';
import 'package:accomod8/services/auth/auth_user.dart';
import 'package:http/http.dart' as http;

class NodeAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String fullName,
    required String email,
    // required String phoneNumber,
    required String password,
    // required String matchingPassword,
  }) async {
    var userBody = {
      'username': fullName,
      'email': email,
      // 'phone': phoneNumber,
      'password': password,
      // 'matching_password': matchingPassword,
    };

    var response = await http.post(
      Uri.parse(registrationUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userBody),
    );

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse);

    final user = currentUser;
    if (user != null) {
      print(response);
      return user;
    } else {
      print(response);
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
  Future<AuthUser> logIn({required String email, required String password}) {
    // TODO: implement logIn
    throw UnimplementedError();
  }
}
