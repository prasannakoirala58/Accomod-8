import 'package:accomod8/utility/dialog/feature_hostel_dialog.dart';
import 'package:accomod8/utility/snackbar/success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:accomod8/services/hostel/node_hostel_provider.dart';

import '../pages/hostel_details_screen.dart';
import '../pages/login_screen.dart';
import '../services/auth/node_auth_provider.dart';
import '../utility/dialog/logout_dialog.dart';
import '../utility/snackbar/error_snackbar.dart';
import '../utility/string_formatter/user_data_formatter.dart';

class AdminHome extends StatefulWidget {
  final String token;
  const AdminHome({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String? token;

  @override
  void initState() {
    token = widget.token;
    super.initState();
  }

  late List<Map<String, dynamic>> hostels;

  Future<List<Map<String, dynamic>>> getHostels() async {
    var hostels = await NodeHostelProvider().getAllHostels();
    return hostels;
  }

  Future<void> featureOrUnfeatureHostel(bool toFeature, String id) async {
    final dynamic response = await NodeHostelProvider()
        .featureOrUnfeatureHostel(toFeature: toFeature, id: id);
    if (response is Map<String, dynamic>) {
      setState(() {
        // Refresh the page by updating the hostels list
        hostels = List<Map<String, dynamic>>.from(hostels);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home Page'),
        actions: [
          IconButton(
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
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getHostels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, dynamic>> hostels = snapshot.data ?? [];
            return ListView.builder(
              itemCount: hostels.length,
              itemBuilder: (context, index) {
                final hostel = hostels[index];
                final bool isFeatured = hostel['featured'] ?? false;
                final bool isVerified = hostel['verified'] ?? false;
                const Color containerColor = Color.fromARGB(255, 242, 162, 131);
                final Color starColor =
                    isFeatured ? Colors.yellow : Colors.grey;
                final Color verifiedIconColor =
                    isVerified ? Colors.green : Colors.red;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HostelDetailsScreen(
                            hostel: hostel,
                            showBookNowButton: false,
                            showDocument: true,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              hostel['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    print('star press');
                                    final shouldChange =
                                        await showFeatureHostelDialog(
                                            context, isFeatured);
                                    if (shouldChange!) {
                                      try {
                                        await featureOrUnfeatureHostel(
                                            !isFeatured, hostel['id']);
                                        setState(() {
                                          SuccessSnackBar.showSnackBar(
                                            context,
                                            isFeatured
                                                ? 'Unfeatured sucessfully'
                                                : 'Featuredsucessfully',
                                          );
                                        });
                                      } on Exception catch (e) {
                                        print('Error:$e');
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.star,
                                    color: starColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    print('verify press');
                                  },
                                  icon: Icon(
                                    Icons.verified,
                                    color: verifiedIconColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Text(
                          hostel['address'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
