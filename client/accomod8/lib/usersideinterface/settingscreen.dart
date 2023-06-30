import 'package:accomod8/services/auth/node_auth_provider.dart';
import 'package:accomod8/utility/dialog/logout_dialog.dart';
import 'package:accomod8/utility/snackbar/error_snackbar.dart';
import 'package:accomod8/utility/snackbar/success_snackbar.dart';
import 'package:flutter/material.dart';

import '../pages/login_screen.dart';
import '../utility/dialog/delete_user_dialog.dart';
import '../utility/string_formatter/user_data_formatter.dart';

class SettingScreen extends StatefulWidget {
  final String token;

  const SettingScreen({
    super.key,
    required this.token,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? token;

  @override
  void initState() {
    token = widget.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "setting page",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () async {
                      Map<String, dynamic> extractedData =
                          UserDataFormatter.extractValues(token!);
                      final String username = extractedData['username'];
                      final shouldLogout = await showLogoutDialog(context);
                      if (shouldLogout) {
                        final logoutSuccess = await NodeAuthProvider().logOut();
                        if (logoutSuccess == 'success') {
                          print('La logout bhayo');
                          print('Before Logout: $token');
                          setState(
                            () {
                              token = null;
                              SuccessSnackBar.showSnackBar(context,
                                  'User $username signed out Successfully');
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LogInScreen(),
                                ),
                              );
                            },
                          );
                        } else {
                          setState(() {
                            ErrorSnackBar.showSnackBar(
                                context, '$username could not be signed out');
                          });

                          print('Oh no logout error bhayo');
                        }
                        print('After Logout: $token');
                      }
                    },
                    child: const Text('Log out'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Map<String, dynamic> extractedData =
                          UserDataFormatter.extractValues(token!);
                      final String username = extractedData['username'];
                      final String id = extractedData['id'];
                      print('ID for deleting:$id');
                      final shouldDelete = await showDeleteUserDialog(context);
                      if (shouldDelete) {
                        final deleteSuccess =
                            await NodeAuthProvider().deleteUser(id: id);
                        if (deleteSuccess == 'success') {
                          print('La delete bhayo');
                          setState(() {
                            SuccessSnackBar.showSnackBar(
                                context, 'User $username Deleted Successfully');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogInScreen(),
                              ),
                            );
                          });
                        } else {
                          print('La delete bhayena');
                          setState(() {
                            ErrorSnackBar.showSnackBar(
                                context, 'Error deleting $username');
                          });
                        }
                      }
                    },
                    child: const Text('Delete Account'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
