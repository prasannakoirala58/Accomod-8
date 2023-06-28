import 'package:accomod8/services/auth/node_auth_provider.dart';
import 'package:accomod8/utility/dialog/logout_dialog.dart';
import 'package:flutter/material.dart';

import '../pages/login_screen.dart';

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
                  Text(
                    "This is setting page",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () async {
                      final shouldLogout = await showLogoutDialog(context);
                      if (shouldLogout) {
                        final logoutSuccess = await NodeAuthProvider().logOut();
                        if (logoutSuccess == 'success') {
                          print('La logout bhayo');
                          print('Before Logout: $token');
                          setState(
                            () {
                              token = null;
                              // Navigator.pushAndRemoveUntil(
                              //     context, LogInScreen, (route) => false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LogInScreen(),
                                ),
                              );
                            },
                          );
                        } else {
                          print('Oh no logout error bhayo');
                        }
                        print('After Logout: $token');
                      }
                    },
                    child: const Text('Log out'),
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
