import 'package:accomod8/services/auth/auth_exceptions.dart';
import 'package:accomod8/services/auth/node_auth_provider.dart';
import 'package:accomod8/utility/snackbar/error_snackbar.dart';
import 'package:accomod8/utility/snackbar/success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:accomod8/pages/login_screen.dart';
//import 'package:flutter_svg/flutter_svg.dart';

enum GenderTypeEnum { Male, Female, Other }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _firstname;
  late final TextEditingController _lastname;
  late final TextEditingController _email;
  late final TextEditingController _username;
  late final TextEditingController _password;
  late final TextEditingController _confirmpassword;
  @override
  void initState() {
    _firstname = TextEditingController();
    _lastname = TextEditingController();
    _email = TextEditingController();
    _username = TextEditingController();
    _password = TextEditingController();
    _confirmpassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstname.dispose();
    _lastname.dispose();
    _email.dispose();
    _username.dispose();
    _password.dispose();
    _confirmpassword.dispose();
    super.dispose();
  }

  bool _passwordVisible = false;

  GenderTypeEnum? _genderTypeEnum;
  bool passToggle = true;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Scaffold(
        body: SingleChildScrollView(
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
                    width: 150,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  child: TextField(
                    controller: _firstname,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        labelText: "First Name *",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person)),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  child: TextField(
                    controller: _lastname,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        labelText: "Last Name *",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person)),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  child: TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: "Email Address *",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email)),
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Radio<GenderTypeEnum>(
                        value: GenderTypeEnum.Male,
                        groupValue: _genderTypeEnum,
                        onChanged: (val) {
                          setState(() {
                            _genderTypeEnum = val;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 0,
                      ),
                      const Text("Male"),
                      Radio<GenderTypeEnum>(
                        value: GenderTypeEnum.Female,
                        groupValue: _genderTypeEnum,
                        onChanged: (val) {
                          setState(() {
                            _genderTypeEnum = val;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 0,
                      ),
                      const Text("Female"),
                      Radio<GenderTypeEnum>(
                        value: GenderTypeEnum.Other,
                        groupValue: _genderTypeEnum,
                        onChanged: (val) {
                          setState(() {
                            _genderTypeEnum = val;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 0,
                      ),
                      const Text("Others"),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  child: TextField(
                    controller: _username,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        labelText: "User Name",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.verified_user)),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _password,
                    //yaha we obscure password wala text so that no one can see it
                    obscureText: passToggle ? true : false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text("Enter Password"),
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
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _confirmpassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    //yaha we obscure password wala text so that no one can see it
                    obscureText: passToggle ? true : false,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text("Confirm Password"),
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
                const SizedBox(height: 10),
                Material(
                  color: const Color.fromARGB(255, 242, 162, 131),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      final firstName = _firstname.text;
                      final lastName = _lastname.text;
                      final email = _email.text;
                      final gender = _genderTypeEnum.toString().split('.').last;
                      final username = _username.text;
                      final password = _password.text;
                      final confirmPassword = _confirmpassword.text;

                      // try {
                      NodeAuthProvider().createUser(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        gender: gender,
                        username: username,
                        password: password,
                        matchingPassword: confirmPassword,
                        userType: 'user',
                      );
                      // } on PasswordDoesNotMatchAuthException {
                      //   ErrorSnackBar.showSnackBar(
                      //     context,
                      //     'Passwords donot match',
                      //   );
                      // } on Exception {
                      //   ErrorSnackBar.showSnackBar(
                      //     context,
                      //     'Authentication error',
                      //   );
                      // }
                      // SuccessSnackBar.showSnackBar(
                      //   context,
                      //   'Yippie',
                      // );

                      ErrorSnackBar.showSnackBar(
                        context,
                        'Opsie',
                      );

                      //Navigator.push(
                      //context,
                      //MaterialPageRoute(
                      //builder: (context) => SignUpScreen(),
                      //)); //Navigator.push(context, MaterialPageRoute(builder: (context)));
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already Have an Account?",
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
                              builder: (context) => const LogInScreen(),
                            ));
                      },
                      child: const Text("Go To Login",
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
