import 'package:accomod8/pages/login_screen.dart';
import 'package:accomod8/services/auth/node_auth_provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NodeAuthProvider().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const LogInScreen(),
    );
  }
}
