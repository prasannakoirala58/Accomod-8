import 'package:accomod8/usersideinterface/explorescreen.dart';
import 'package:accomod8/usersideinterface/favouritesscreen.dart';
import 'package:accomod8/usersideinterface/settingscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBarRoots extends StatefulWidget {
  const NavBarRoots({super.key});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    //Explore screen
    ExploreScreen(),
    //Add later on
    Container(),
    //Favourite
    FavouriteScreen(),
    //Setting Screen
    SettingScreen(),
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
              label: "Explore",
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
