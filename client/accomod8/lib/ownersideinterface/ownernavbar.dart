import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OwnerNavBar extends StatefulWidget {
  const OwnerNavBar({super.key});

  @override
  State<OwnerNavBar> createState() => _OwnerNavBarState();
}

class _OwnerNavBarState extends State<OwnerNavBar> {
  int _selectedIndex = 0;
  final _screens = [
    //HomeScreen
    Container(),
    //kk
    Container(),
    //kk
    Container(),
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
                Icons.home_filled,
                size: 25,
              ),
              label: "Add Hostels",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home, size: 25),
              label: "Manage Hostels",
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
