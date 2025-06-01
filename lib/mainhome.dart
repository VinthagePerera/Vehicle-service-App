import 'package:flutter/material.dart';
import 'package:project1/Profile.dart';
import 'package:project1/home.dart';
import 'package:project1/user_service_history.dart';

class Mainhome extends StatefulWidget {
   Mainhome({Key? key}) : super(key: key ?? GlobalKey()); 

  @override
  State<Mainhome> createState() => _MainhomeState();
}

class _MainhomeState extends State<Mainhome> {
  int index = 0; 
  final screens = [
    Home(),
    UserServiceHistory(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (int index) => setState(() => this.index = index), 
          backgroundColor: const Color(0xFF519EB7),
          destinations: [
            NavigationDestination(
                icon: Image.asset('assets/icons/Home.png'), label: 'Home'),
            NavigationDestination(
                icon: Image.asset('assets/icons/Time Machine.png'),
                label: 'History'),
            NavigationDestination(
              icon: Image.asset('assets/icons/Customer.png'),
              label: 'Profile',
            )
          ],
        ),
      ),
    );
  }
}
