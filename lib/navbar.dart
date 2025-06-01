import 'package:flutter/material.dart';
import 'package:project1/addcars.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFe8f7fb),
      child: ListView(
        children: [
          Image.asset('assets/logo2.png'),
          const SizedBox(
            height: 10,
          ),
          const Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Divider(
                thickness: 4,
              )),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.car_repair),
            title: const Text(
              'Add cars',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyCarsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text(
              'About us',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.car_repair),
            title: const Text(
              'Privacy and Policy',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {},
          ),
          const Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Divider(
                thickness: 4,
              )),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
