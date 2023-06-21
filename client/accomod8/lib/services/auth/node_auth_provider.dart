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

    return jsonResponse;
    // final user = currentUser;
    // if (user != null) {
    //   print('response');
    //   return user;
    // } else {
    //   print('cringe');
    //   throw 'a';
  }

// @override
// AuthUser? get currentUser async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences pref = await SharedPreferences.getInstance();

//   var username = pref.getString('username');
//   final user = username.toString();
//   if (user != null) {
//     return user;
//   } else {
//     return null;
//   }
//   // const MyApp({@required token, Key? key,}):super(key: key);
// }

// @override
// AuthUser? get currentUser async {
//   final user = prefs.getString('username');
//   if (user != null){
//     return <AuthUser>;
//   }
// }

  @override
  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<String> logIn({
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

    if (jsonResponse['token'] == null) {
      print('no token');
      throw WrongCredentialsAuthException();
    } else {
      var token = jsonResponse['token'];
      prefs.setString(
        'token',
        token,
      );
      print(token);
      print('login');
      return token;
      // final user = prefs.getString('username');
      // return user;
    }

    //   final user = currentUser;
    //   if (user != null) {
    //     print('response');
    //     return user;
    //   } else {
    //     print('cringe');
    //     throw 'a';
    //   }
    // }

    // @override
    // // TODO: implement currentUser
    // AuthUser? get currentUser => throw UnimplementedError();
  }
}
