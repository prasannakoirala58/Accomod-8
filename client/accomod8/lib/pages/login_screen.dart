import 'package:accomod8/adminsideinterface/admin_home.dart';
import 'package:accomod8/ownersideinterface/ownernavbar.dart';
import 'package:accomod8/pages/signup_screen.dart';
import 'package:accomod8/services/auth/node_auth_provider.dart';
import 'package:accomod8/usersideinterface/navbarroots.dart';
import 'package:accomod8/utility/snackbar/error_snackbar.dart';
import 'package:accomod8/utility/snackbar/success_snackbar.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_exceptions.dart';
import '../utility/string_formatter/user_data_formatter.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formField = GlobalKey<FormState>();
  //final _formField = GlobalKey<FormState>();

  late final TextEditingController _email;
  late final TextEditingController _password;
  late final String _loginToken;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formField,
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    "images/xdd.png",
                    height: 170,
                    width: 300,
                  ),
                ),
                const SizedBox(
                  height: 0,
                ),
                const SizedBox(height: 75),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextFormField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      // filled: true,
                      // fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 242, 162, 131),
                        ),
                      ),
                      labelText: "Enter Email",
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email cannot be empty";
                      }
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return "Invalid Email";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextFormField(
                    controller: _password,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      // filled: true,
                      // fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 242, 162, 131),
                        ),
                      ),
                      labelText: "Enter Password",

                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Password";
                      } else if (_password.text.length < 6) {
                        return "Password lenghth should not be less than 6 characters";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Material(
                        color: const Color.fromARGB(255, 213, 127, 93),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () async {
                            final email = _email.text;
                            final password = _password.text;

                            // if (email.isEmpty || password.isEmpty) {
                            //   ErrorSnackBar.showSnackBar(
                            //     context,
                            //     'Fields cannot be empty',
                            //   );
                            //   throw FieldsCannotBeEmptyException;
                            // }
                            if (_formField.currentState!.validate()) {
                              try {
                                _loginToken = await NodeAuthProvider().logIn(
                                  email: email,
                                  password: password,
                                );
                                // cookieUtil.retrieveDataFromCookie();
                                print('Token in Login:$_loginToken');

                                Map<String, dynamic> extractedData =
                                    UserDataFormatter.extractValues(
                                        _loginToken);
                                final userType = extractedData['usertype'];
                                // print('Usertype:$userType');

                                setState(() {
                                  SuccessSnackBar.showSnackBar(
                                    context,
                                    'Logged in successfully',
                                  );
                                  if (userType == 'user') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NavBarRoots(
                                          token: _loginToken,
                                        ),
                                      ),
                                    );
                                  } else if (userType == 'admin') {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const AdminHome(
                                            // token: _loginToken,
                                            ),
                                      ),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OwnerNavBar(
                                          token: _loginToken,
                                        ),
                                      ),
                                    );
                                  }
                                });

                                // SuccessSnackBar.showSnackBar(
                                //   context,
                                //   'Logged in successfully',
                                // );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => NavBarRoots(
                                //       token: _loginToken,
                                //     ),
                                //   ),
                                // );

                                // print('ok data aayo');
                                // print(_loginToken);
                              } on WrongCredentialsAuthException {
                                ErrorSnackBar.showSnackBar(
                                  context,
                                  'Wrong Credentials',
                                );
                                // } on FieldsCannotBeEmptyException catch (_) {
                                //   ErrorSnackBar.showSnackBar(
                                //     context,
                                //     'Fields cannot be empty',
                                //   );
                              } on Exception catch (e) {
                                ErrorSnackBar.showSnackBar(
                                  context,
                                  e.toString(),
                                );

                                print('Login Error:${e.toString()}');
                              }
                            }
                            // ErrorSnackBar.showSnackBar(
                            //   context,
                            //   'Hmmmmmm',
                            // );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't Have an Account?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    //here create an account wala button press garyo vane we will go to signup screen
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ));
                      },
                      child: const Text("Create an Account",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 242, 162, 131),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
