import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project1/mycars.dart';
import 'package:project1/navbar.dart';
import 'package:project1/userlocation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final currentUser = FirebaseAuth.instance.currentUser;
  late final FirebaseFirestore _firestore;

  final myitems = [
    Image.asset('assets/ratguard.png'),
    Image.asset('assets/oilchange.png'),
    Image.asset('assets/tirechange.png'),
    Image.asset('assets/carwash.png'),
  ];

  int index = 0;

  final categories = [
    Image.asset('assets/sratguard.png'),
    Image.asset('assets/soilchange.png'),
    Image.asset('assets/stirechange.png'),
    Image.asset('assets/scarwash.png'),
    Image.asset('assets/alignment.png'),
  ];

  final labels = [
    'Rat Guard',
    'Oil Change',
    'Tire Replace',
    'Car Wash',
    'Alignment',
  ];

  String selectedCategory = '';

  String? servicetype;
  void _selectUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Store user's location in Firestore
    await _firestore.collection('user_locations').add({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now(),
      'userId': currentUser?.uid,
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('User location selected and stored in Firestore.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Navbar(),
        backgroundColor: const Color(0xFFe8f7fb),
        appBar: AppBar(
          backgroundColor: const Color(0xFF519EB7),
          title: const Center(child: Text('Service Categories')),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                      child: Image.asset(
                        'assets/Map.png',
                        fit: BoxFit.cover,
                        height: 190,
                        width: 700,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          const Text(
                            'Location',
                            style: TextStyle(
                                fontSize: 17, color: Color(0xFFE8F7FB)),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CurrentLocationScreen(),
                                  ));
                            },
                            label: const Text('Select Your Location'),
                            icon: const Icon(Icons.location_city),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          height: 170,
                          onPageChanged: (index, reason) {
                            setState(() {
                              index = index;
                            });
                          },
                        ),
                        items: myitems.map((item) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: item,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 7),
                      AnimatedSmoothIndicator(
                        activeIndex: index,
                        count: myitems.length,
                      ),
                      const SizedBox(height: 14),
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(thickness: 2, color: Colors.grey),
                          ),
                          Text(
                            'Services',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 2, 7, 81)),
                          ),
                          Expanded(
                            child: Divider(thickness: 3, color: Colors.grey),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 70.0,
                        runSpacing: 20.0,
                        children: [
                          for (var i = 0; i < categories.length; i++)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCategory = labels[i];
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Mycars(
                                        servicetype:
                                            selectedCategory), // Pass selectedCarType
                                  ),
                                );
                                print(selectedCategory);
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      width: 58,
                                      height: 58,
                                      color: Colors.grey,
                                      child: categories[i],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    labels[i],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Divider(thickness: 3),
                      if (currentUser != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Welcome, ${currentUser?.email}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Welcome, Guest',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
