import 'package:flutter/material.dart';
import '../utility/string_formatter/user_data_formatter.dart';

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
  String username = '';

  @override
  void initState() {
    // extracting username from token
    // can be later used to extract other values from token
    try {
      Map<String, dynamic> extractedData =
          UserDataFormatter.extractValues(widget.token);

      setState(
        () {
          username = extractedData['username'];
        },
      );
    } on Exception catch (e) {
      setState(
        () {
          username = 'Error';
        },
      );
      print('Error in explore page:$e');
    }
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
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
