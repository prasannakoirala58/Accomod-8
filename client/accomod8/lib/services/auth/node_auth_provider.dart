import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:accomod8/config.dart';
import 'package:accomod8/services/auth/auth_provider.dart';
// import 'package:accomod8/services/auth/auth_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_exceptions.dart';

class NodeAuthProvider implements AuthProvider {
  static late SharedPreferences prefs;

  @override
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
  }) async {
    if (matchingPassword != password) {
      throw PasswordDoesNotMatchAuthException;
    }
    Dio dio = Dio();
    String photoFileName = image.path.split('/').last;
    String documentFileName = document.path.split('/').last;

    // print('photoFile:$photoFileName, documentFile:$documentFileName');

    // Package formData
    FormData formData = FormData.fromMap(
      {
        'username': username,
        'email': email,
        'password': password,
        'typeof_user': userType,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'profile_picture': await MultipartFile.fromFile(
          image.path,
          filename: photoFileName,
          contentType: MediaType('image', 'png'),
        ),
        'document': await MultipartFile.fromFile(
          document.path,
          filename: documentFileName,
          contentType: MediaType('image', 'png'),
        ),
      },
    );

    // send formData
    try {
      Response formDataresponse = await dio.post(
        registerUrl,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print('RawResponse:$formDataresponse');
      final formDataSuccessStatus = formDataresponse.data['status'];
      return formDataSuccessStatus;
    } on Exception catch (e) {
      print(
        e.toString(),
      );
      return '';
    }
  }

  @override
  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<String> logIn({
    required String email,
    required String password,
  }) async {
    var loginUserBody = {
      "email": email,
      "password": password,
    };
    var response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
      },
      body: jsonEncode(loginUserBody),
    );

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse);

    if (jsonResponse['status'] == 'success') {
      var token = jsonResponse['data'];
      // prefs.setString(
      //   'data',
      //   token,
      // );
      print(token.toString());
      print('login');
      return token.toString();
    } else {
      print('no token');
      throw WrongCredentialsAuthException();
    }
  }

  @override
  Future<String> logOut() async {
    var response = await http.get(
      Uri.parse(logoutUrl),
    );

    var jsonResponse = jsonDecode(response.body);
    print('Logout JSON:$jsonResponse');
    if (jsonResponse['status'] == 'success') {
      print('Logout');
    } else {
      print('Error logging out');
    }
    return jsonResponse['status'];
  }

  @override
  Future<String> deleteUser({required String id}) async {
    var deletingUrl = '$deleteUrl/$id';
    print('Deleting url: $deletingUrl');
    var response = await http.delete(Uri.parse(deletingUrl));
    // var response = await http.delete(Uri.parse(deleteUrl));
    var jsonResponse = jsonDecode(response.body);
    print('Delete JSON:$jsonResponse');
    if (jsonResponse['status'] == 'success') {
      print('Delete');
    } else {
      jsonResponse['status'] = 'failure';
      print('Error deleting');
    }
    // return 'no';
    return jsonResponse['status'];
  }
}
