import 'dart:io';
import 'package:accomod8/services/auth/auth_exceptions.dart';
import 'package:accomod8/services/auth/node_auth_provider.dart';
import 'package:accomod8/utility/image_uploader/upload_image.dart';
import 'package:accomod8/utility/snackbar/error_snackbar.dart';
import 'package:accomod8/utility/snackbar/success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:accomod8/pages/login_screen.dart';
//import 'package:flutter_svg/flutter_svg.dart';

enum GenderTypeEnum { male, female, others }

enum UserTypeEnum { user, owner }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formField = GlobalKey<FormState>();
  File? selectedImageFromGallery;
  File? selectedImageFromCamera;
  late final TextEditingController _firstname;
  late final TextEditingController _lastname;
  late final TextEditingController _email;
  late final TextEditingController _username;
  late final TextEditingController _password;
  late final TextEditingController _confirmpassword;

  _SignUpScreenState();
  @override
  void initState() {
    // selectedImageFromGallery;
    // selectedImageFromCamera;
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
  UserTypeEnum? _userTypeEnum;
  bool passToggle = true;
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
                    "images/acclog.png",
                    height: 100,
                    width: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () async {
                      selectedImageFromCamera =
                          await ImageUploader().selectImageFromCamera();
                      print(
                          'Camera image Path in Signup$selectedImageFromCamera');
                    },
                    child: const Text('Pick Image from Camera'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () async {
                      selectedImageFromGallery =
                          await ImageUploader().selectImageFromGallery();
                      print(
                          'Gallery image Path in Signup$selectedImageFromGallery');
                    },
                    child: const Text('Pick Image from Gallery'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: selectedImageFromCamera != null
                        ? Image.file(
                            selectedImageFromCamera!,
                            height: 100,
                            width: 150,
                          )
                        : const Text('Camera image is shown here')),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: selectedImageFromGallery != null
                        ? Image.file(
                            selectedImageFromGallery!,
                            height: 100,
                            width: 150,
                          )
                        : const Text('Gallery image is shown here')),
                const SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  child: TextFormField(
                    controller: _firstname,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: "First Name *",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 242, 162, 131))),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter First Name";
                      }
                      if (value.startsWith(RegExp(r'[0-9]'))) {
                        return 'First name cannot start with a number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  child: TextFormField(
                    controller: _lastname,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: "Last Name *",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 242, 162, 131),
                        ),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Last Name";
                      }
                      if (value.startsWith(RegExp(r'[0-9]'))) {
                        return 'Last name cannot start with a number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  child: TextFormField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email Address *",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 242, 162, 131),
                        ),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Email';
                      }
                      if (value.startsWith(RegExp(r'[0-9]'))) {
                        return 'Last name cannot start with a number';
                      }
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return "Enter valid Email";
                      }
                      return null;
                    },
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Radio<GenderTypeEnum>(
                        value: GenderTypeEnum.male,
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
                        value: GenderTypeEnum.female,
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
                        value: GenderTypeEnum.others,
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
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    children: [
                      Radio<UserTypeEnum>(
                        value: UserTypeEnum.user,
                        groupValue: _userTypeEnum,
                        onChanged: (val) {
                          setState(() {
                            _userTypeEnum = val;
                          });
                        },
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      Text("User"),
                      Radio<UserTypeEnum>(
                        value: UserTypeEnum.owner,
                        groupValue: _userTypeEnum,
                        onChanged: (val) {
                          setState(() {
                            _userTypeEnum = val;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 0,
                      ),
                      const Text("Owner"),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                  child: TextFormField(
                    controller: _username,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: "User Name",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 242, 162, 131),
                        ),
                      ),
                      prefixIcon: Icon(Icons.verified_user),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your username";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _password,
                    //yaha we obscure password wala text so that no one can see it
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 242, 162, 131),
                        ),
                      ),
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
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 242, 162, 131),
                        ),
                      ),
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
                    onTap: () async {
                      final firstName = _firstname.text;
                      final lastName = _lastname.text;
                      final email = _email.text;
                      final gender = _genderTypeEnum.toString().split('.').last;
                      final username = _username.text;
                      final password = _password.text;
                      final confirmPassword = _confirmpassword.text;

                      // if (firstName.isEmpty ||
                      //     lastName.isEmpty ||
                      //     email.isEmpty ||
                      //     gender.isEmpty ||
                      //     username.isEmpty ||
                      //     password.isEmpty ||
                      //     confirmPassword.isEmpty) {
                      //   ErrorSnackBar.showSnackBar(
                      //     context,
                      //     'Fields cannot be empty',
                      //   );
                      //   throw FieldsCannotBeEmptyException;
                      // }
                      if (_formField.currentState!.validate()) {
                        try {
                          // send request to server
                          final response = await NodeAuthProvider().createUser(
                            firstName: firstName,
                            lastName: lastName,
                            email: email,
                            gender: gender,
                            username: username,
                            password: password,
                            matchingPassword: confirmPassword,
                            userType: 'user',
                            image: File(selectedImageFromGallery!.path),
                            document: File(selectedImageFromCamera!.path),
                          );

                          if (response == 'success') {
                            SuccessSnackBar.showSnackBar(
                              context,
                              'Signed up sucessfully',
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogInScreen(),
                              ),
                            );
                          } else {
                            ErrorSnackBar.showSnackBar(
                              context,
                              'Username and email should be unique',
                            );
                          }
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const LogInScreen(),
                          //     ));
                          //Navigator.push(
                          //context,
                          //MaterialPageRoute(
                          //builder: (context) => SignUpScreen(),
                          //)); //Navigator.push(context, MaterialPageRoute(builder: (context)));
                          // } on FieldsCannotBeEmptyException catch (_) {
                          //   ErrorSnackBar.showSnackBar(
                          //     context,
                          //     'Fields cannot be empty',
                          //   );
                        } on PasswordDoesNotMatchAuthException {
                          ErrorSnackBar.showSnackBar(
                            context,
                            'Password does not match',
                          );
                        } on Exception catch (e) {
                          print(e.toString());
                          ErrorSnackBar.showSnackBar(
                            context,
                            'e.toString()',
                          );
                        }
                      }
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
                      ),
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
                      child: const Text(
                        "Go To Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 242, 162, 131),
                        ),
                      ),
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
