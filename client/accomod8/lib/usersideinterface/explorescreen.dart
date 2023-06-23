import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  final String token;
  const ExploreScreen({
    super.key,
    required this.token,
  });

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
                  Text("This is explore page",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w500))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
