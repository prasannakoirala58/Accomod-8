import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ExploreScreen extends StatefulWidget {
  final String token;
  const ExploreScreen({
    super.key,
    required this.token,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final String username;

  @override
  void initState() {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    username = jwtDecodedToken['username'];
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
                  Text("This is explore page for $username",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
