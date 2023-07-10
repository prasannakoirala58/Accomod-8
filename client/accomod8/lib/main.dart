import 'package:accomod8/config.dart';
import 'package:accomod8/pages/login_screen.dart';
import 'package:accomod8/services/auth/node_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NodeAuthProvider().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: khaltiTestPublicKey,
      enabledDebugging: true,
      builder: (
        context,
        navKey,
      ) {
        return MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
          // themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          home: const LogInScreen(),
          navigatorKey: navKey,
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
        );
      },
    );
  }
}
