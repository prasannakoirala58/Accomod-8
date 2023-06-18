import 'package:accomod8/pages/login_screen.dart';
// import 'package:accomod8/services/auth/node_auth_provider.dart';

import 'package:accomod8/utility/snackbar/error_snackbar.dart';

import 'package:flutter/cupertino.dart';
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
  GenderTypeEnum? _genderTypeEnum;
  bool passToggle = true;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "First Name *",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person)),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Last Name *",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person)),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
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
              SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "User Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.verified_user)),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  //yaha we obscure password wala text so that no one can see it
                  obscureText: passToggle ? true : false,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text("Enter Password"),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (passToggle == true) {
                            passToggle == false;
                          } else {
                            passToggle == true;
                          }
                          setState(() {});
                        },
                        child: passToggle
                            ? const Icon(CupertinoIcons.eye_slash_fill)
                            : const Icon(CupertinoIcons.eye_fill),
                      )),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  //yaha we obscure password wala text so that no one can see it
                  obscureText: passToggle ? true : false,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text("Confirm Password"),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (passToggle == true) {
                            passToggle == false;
                          } else {
                            passToggle == true;
                          }
                          setState(() {});
                        },
                        child: passToggle
                            ? const Icon(CupertinoIcons.eye_slash_fill)
                            : const Icon(CupertinoIcons.eye_fill),
                      )),
                ),
              ),
              const SizedBox(height: 10),
              Material(
                color: const Color.fromARGB(255, 242, 162, 131),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {

                    // NodeAuthProvider().createUser(
                    //   fullName: 'fullName',
                    //   email: 'email',
                    //   password: 'password',
                    // );

                    const ErrorSnackBar(message: 'Cringe');

                    //Navigator.push(
                    //context,
                    //MaterialPageRoute(
                    //builder: (context) => SignUpScreen(),
                    //)); //Navigator.push(context, MaterialPageRoute(builder: (context)));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
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
    );
  }
}
