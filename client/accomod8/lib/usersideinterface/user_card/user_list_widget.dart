import 'package:accomod8/usersideinterface/user_card/user_cards.dart';
import 'package:flutter/material.dart';

class UserListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  const UserListWidget({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // Number of items per row
      crossAxisCount: 2,

      // Vertical spacing between rows
      mainAxisSpacing: 8.0,

      // Horizontal spacing between items
      crossAxisSpacing: 8.0,
      children: users.map((user) => UserCard(user: user)).toList(),
    );
  }
}
