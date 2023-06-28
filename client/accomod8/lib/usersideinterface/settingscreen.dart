import 'package:accomod8/services/auth/node_auth_provider.dart';
import 'package:accomod8/utility/dialog/logout_dialog.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
                        } else {
                          print('Oh no logout error bhayo');
                        }
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
