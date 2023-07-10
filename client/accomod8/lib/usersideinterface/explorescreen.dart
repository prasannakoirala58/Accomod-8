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
  String? token;
  String username = '';

  @override
  void initState() {
    token = widget.token;
    print('Token in Explore:$token');
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
                  Text(
                    "Welcome $username",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 242, 162, 131),
                        ),
                      ),
                      hintText: "Browse Hostels...",
                      prefixIcon: Icon(Icons.search_sharp),
                      prefixIconColor: Color.fromARGB(255, 242, 162, 131),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Popular Hostels",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: 6,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 2)
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                        ),
                      );
                    }),
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
