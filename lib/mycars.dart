
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/appoinment.dart';


class Mycars extends StatefulWidget {
  final String? servicetype;
  const Mycars({super.key,required this.servicetype});

  @override
  State<Mycars> createState() => _MycarsState();
}

class _MycarsState extends State<Mycars> {
  String? currentUserId;
  String? selectedCarType;
  String? servicetype; 

  @override
  void initState() {
    super.initState();
    getCurrentUserId();

    servicetype = widget.servicetype;
  }

  void getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.email;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Select Your car')),
          backgroundColor: const Color(0xFF519EB7),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final userCars = snapshot.data!.docs
                .where((doc) => doc['email'] == currentUserId)
                .map((doc) => doc['userCars'] as List<dynamic>?)
                .toList();

            if (userCars.isEmpty) {
              return const Center(
                child: Text('User data not found'),
              );
            }

            final cars = userCars[0];

            if (cars == null || cars.isEmpty) {
              return const Center(
                child: Text('No cars found for the user'),
              );
            }

            return ListView.builder(
              itemCount: cars.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCarType = cars[index].toString();
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Appointment(
                            selectedCarType: selectedCarType, 
                            servicetype: servicetype,), 
                        ),
                      );
                    },
                    child: Container(
                      height: 80,
                      width: 700,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 11, 1, 1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          cars[index].toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        
      ),
    );
  }
}
