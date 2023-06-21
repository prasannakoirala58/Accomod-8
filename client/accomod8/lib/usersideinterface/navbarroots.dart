import 'package:accomod8/usersideinterface/explorescreen.dart';
import 'package:accomod8/usersideinterface/favouritesscreen.dart';
import 'package:accomod8/usersideinterface/settingscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

class NavBarRoots extends StatefulWidget {
  final token;
  const NavBarRoots({
    super.key,
    required this.token,
  });

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  late String navToken;
  late String email;
  @override
  void initState() {
    super.initState();
    navToken = widget.token;
    // Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    // email = jwtDecodedToken['username'];
  }

  _NavBarRootsState() {
    // finalbartoken=super.widget.token;
    // required super.token;
  }

  int _selectedIndex = 0;
  final _screens = [
    //Explore screen
    ExploreScreen(
      token: 'navToken',
    ),
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
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 25,
              ),
              // label: email,
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
