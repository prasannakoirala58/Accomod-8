import 'package:accomod8/usersideinterface/explorescreen.dart';
import 'package:accomod8/usersideinterface/favouritesscreen.dart';
import 'package:accomod8/usersideinterface/settingscreen.dart';
import 'package:accomod8/usersideinterface/user_card/user_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

class NavBarRoots extends StatefulWidget {
  final String token;
  const NavBarRoots({
    Key? key,
    required this.token,
  }) : super(key: key);

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  List<Widget> get _screens => [
        //Explore screen
        ExploreScreen(
          token: widget.token,
        ),

        //For displaying users. will be later replaced and be implemented on explore scrreen
        UserListScreen(
          token: widget.token,
        ),

        //Add later on
        Container(),

        //Favourite
        FavouriteScreen(),

        //Setting Screen
        SettingScreen(
          token: widget.token,
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(255, 242, 162, 131),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          currentIndex: _selectedIndex,
          onTap: (Index) {
            setState(() {
              _selectedIndex = Index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 25,
              ),

              // label: email,
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_box,
                size: 25,
              ),
              label: "Users",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart_circle_fill, size: 25),
              label: "Favourites",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart_circle_fill, size: 25),
              label: "Favourites",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 25),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
