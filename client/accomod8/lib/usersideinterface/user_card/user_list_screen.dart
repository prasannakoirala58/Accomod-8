import 'package:accomod8/usersideinterface/user_card/user_detail_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../services/auth/node_auth_provider.dart';

class UserListScreen extends StatefulWidget {
  final String token;

  const UserListScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  Future<List<Map<String, dynamic>>> getUsers() async {
    // Your logic to fetch users
    var users = await NodeAuthProvider().getAllUsers();
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, dynamic>> users = snapshot.data ?? [];
            final List<Map<String, dynamic>> owners = users
                .where((user) => user['usertype']['typeof_user'] == 'owner')
                .toList();
            final List<Map<String, dynamic>> remainingUsers = users
                .where((user) => user['usertype']['typeof_user'] != 'owner')
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: CarouselSlider(
                    items: owners.map<Widget>((user) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailScreen(
                                email: user['email'],
                                userType: user['usertype']['typeof_user'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  user['profile']['profile_picture'],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${user['profile']['first_name']} ${user['profile']['last_name']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          1.5, // Adjust the aspect ratio as needed
                    ),
                    itemCount: remainingUsers.length,
                    itemBuilder: (context, index) {
                      final user = remainingUsers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailScreen(
                                email: user['email'],
                                userType: user['usertype']['typeof_user'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  user['profile']['profile_picture'],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${user['profile']['first_name']} ${user['profile']['last_name']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
