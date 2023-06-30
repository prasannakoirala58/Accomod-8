import 'package:accomod8/usersideinterface/user_card/user_list_widget.dart';
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
    var users = await NodeAuthProvider().getAllUsers();
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // for showing a loading indicator while fetching data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // for showing an error message if data fetching fails
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display the UserListWidget with the fetched users data
            return UserListWidget(users: snapshot.data ?? []);
          }
        },
      ),
    );
  }
}
