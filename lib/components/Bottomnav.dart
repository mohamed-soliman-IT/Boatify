import 'package:flutter/material.dart';
import 'package:Boatify/screens/Add-yachtOrTrip.dart';
import '../screens/Home.dart';
import '../screens/AllTripsPage.dart';
import '../screens/ProfilePage.dart';
import '../screens/map.dart';

class BottomNav extends StatefulWidget {
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int is_selected = 0;

  final List<Widget> _pages = [
    HomePage(),
    AllTripsPage(),
    MapScreen(),
    ProfilePage(),
    YachOrTrip(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[is_selected],
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 21, 41, 58),
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Color.fromARGB(255, 88, 224, 158),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: is_selected,
            onTap: (value) {
              setState(() {
                is_selected = value;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.house), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.sailing), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_pin), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
            ]),
      ),
    );
  }
}
