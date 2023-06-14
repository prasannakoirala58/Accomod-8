import 'package:accomod8/pages/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
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
                  width: 200,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: EdgeInsets.all(12),
              //   child: Text(
              //     "Login",
              //     style: TextStyle(color: Colors.black, fontSize: ),
              //   ),
              // ),
              const SizedBox(height: 75),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      label: const Text("Enter Username"),
                      prefixIcon: const Icon(Icons.person)),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  obscureText: passToggle ? true : false,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      label: const Text(
                        "Enter Password",
                        style: TextStyle(fontSize: 20),
                      ),
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
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Color.fromARGB(255, 242, 162, 131),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ));
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 40),
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
    );
  }
}
