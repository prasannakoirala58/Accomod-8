import 'package:accomod8/pages/signup_screen.dart';
import 'package:accomod8/services/auth/node_auth_provider.dart';
import 'package:accomod8/usersideinterface/navbarroots.dart';
import 'package:accomod8/utility/snackbar/error_snackbar.dart';
import 'package:accomod8/utility/snackbar/success_snackbar.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_exceptions.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
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
    return Material(
      color: Colors.white,
      child: Scaffold(
        body: SingleChildScrollView(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      "images/acclog.png",
                      height: 100,
                      width: 200,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 75),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        // filled: true,
                        // fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: "User Name",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 242, 162, 131),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _password,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        // filled: true,
                        // fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        labelText: "Enter Password",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 242, 162, 131),
                          ),
                        ),
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

<<<<<<< HEAD
                            if (email.isEmpty || password.isEmpty) {
                              ErrorSnackBar.showSnackBar(
                                context,
                                'Fields cannot be empty',
                              );
                              throw FieldsCannotBeEmptyException;
                            }
                            try {
                              _loginToken = await NodeAuthProvider().logIn(
                                email: email,
                                password: password,
                              );
                              SuccessSnackBar.showSnackBar(
                                context,
                                'Logged in successfully',
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NavBarRoots(
                                    token: _loginToken,
                                  ),
=======
                          if (email.isEmpty || password.isEmpty) {
                            ErrorSnackBar.showSnackBar(
                              context,
                              'Fields cannot be empty',
                            );
                            throw FieldsCannotBeEmptyException;
                          }
                          try {
                            _loginToken = await NodeAuthProvider().logIn(
                              email: email,
                              password: password,
                            );
                            print('Token in client:$_loginToken');
                            SuccessSnackBar.showSnackBar(
                              context,
                              'Logged in successfully',
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NavBarRoots(
                                  token: _loginToken,
>>>>>>> 3598c328517bf3f7a291620216bd027fa43f15de
                                ),
                              );
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't Have an Account?",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
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
      ),
    );
  }
}
