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

    // var formDataJsonResponse = jsonDecode(formDataresponse.data);
    // print('FormData:$formDataJsonResponse');

    // sending data in json form
    // var registerUserBody = {
    //   'username': username,
    //   'email': email,
    //   'password': password,
    //   "typeof_user": userType,
    //   "first_name": firstName,
    //   "last_name": lastName,
    //   "gender": gender,
    // };

    // var response = await http.post(
    //   Uri.parse(registerUrl),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(registerUserBody),
    // );

    // var jsonResponse = jsonDecode(response.body);
    // print(jsonResponse);
    // final keyR = jsonResponse['message:'];
    // print('Recived:$keyR');
    // final successStatus = jsonResponse['success'];
    // print("resp:$resp");
    // Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(jsonResponse);
    // print('res:$jwtDecodedToken');

    // factory; NodeAuthProvider.fromJson(Map<String, dynamic>jsonData)=> NodeAuthProvider(
    //   status: jsonData['success'] as bool,
    // );
    // final successResponse = jwtDecodedToken['success'];

    // print(successResponse);

    // print('StringRes:$formDataresponse.data.toString()');

    // Map<String, dynamic> decodedSuccessStatus =
    //     JwtDecoder.decode(formDataresponse);

    // print('SucStat:$formDataSuccessStatus');

    // return successStatus;
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
    required String email,
    required String password,
  }) async {
    var loginUserBody = {
      "email": email,
      "password": password,
    };
    var response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
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
