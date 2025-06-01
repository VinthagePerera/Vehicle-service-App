import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFe8f7fb),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 0, top: 30),
                child: Text(
                  'Experiences \n      Effortless \ncar service \n         Solution',
                  style: TextStyle(
                      fontSize: 40.0,
                      color: Color(0xFF24186D),
                      fontFamily: 'Alegreyasans'),
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBFDDE4),
                        fixedSize: const Size(191.0, 60)),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF278B4F),
                          fontFamily: 'Alegreyasans'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              const Align(
                  alignment: Alignment.bottomLeft,
                  child: Image(image: AssetImage('assets/page1img.png')))
            ],
          ),
        ),
      ),
    );
  }
}
