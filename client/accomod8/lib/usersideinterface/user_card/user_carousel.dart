// currently useless

import 'package:accomod8/usersideinterface/user_card/user_cards.dart';
import 'package:flutter/material.dart';

class UserCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const UserCarousel({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5, // Adjust the aspect ratio as needed
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(user: user);
      },
    );
  }
}
