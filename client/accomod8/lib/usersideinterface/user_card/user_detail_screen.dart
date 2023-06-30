import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  final String email;
  final String userType;
  const UserDetailScreen({
    Key? key,
    required this.email,
    required this.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Column(
        children: [
          Text(
            'Email: $email',
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            'Type: $userType',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
