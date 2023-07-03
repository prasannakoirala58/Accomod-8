import 'package:flutter/material.dart';

import '../pages/login_screen.dart';
import '../services/auth/node_auth_provider.dart';
import '../utility/dialog/logout_dialog.dart';
import '../utility/snackbar/error_snackbar.dart';
import '../utility/snackbar/success_snackbar.dart';
import '../utility/string_formatter/user_data_formatter.dart';

class OwnerSetting extends StatefulWidget {
  final String token;
  const OwnerSetting({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<OwnerSetting> createState() => _OwnerSettingState();
}

class _OwnerSettingState extends State<OwnerSetting> {
  String? token;

  @override
  void initState() {
    token = widget.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: TextButton(
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
                      SuccessSnackBar.showSnackBar(
                          context, 'User $username signed out Successfully');
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
            child: const Text(
              'Log out',
            ),
          ),
        ),
      ),
    );
  }
}
