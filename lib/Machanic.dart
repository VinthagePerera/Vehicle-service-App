import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/confirmbooking.dart';

class Machanic extends StatefulWidget {
  final String? selectedCarType;
  final String? servicetype;
  final DateTime Today;
  final String? selectedTimeSlotIndex;

  Machanic(
      {Key? key,
      required this.selectedCarType,
      required this.servicetype,
      required this.selectedTimeSlotIndex,
      required this.Today})
      : super(key: key);

  @override
  _MachanicState createState() => _MachanicState();
}

class _MachanicState extends State<Machanic> {
  List<String> carList = [];
  List<String> filteredmechanic = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserId;
  String? selectedMechanic;

  DateTime? Today;
  String? selectedTimeSlotIndex;
  String? selectedCarType;
  String? servicetype;

  @override
  void initState() {
    super.initState();
    carlist();
    getCurrentUserId();

    servicetype = widget.servicetype;
    selectedCarType = widget.selectedCarType;
    servicetype = widget.servicetype;
    Today = widget.Today;
    selectedTimeSlotIndex = widget.selectedTimeSlotIndex;
    print('service type=$servicetype');
    print('service type=$selectedCarType');
  }

  void getCurrentUserId() async {
    currentUserId = await fetchCurrentUserId();
    setState(() {});
  }

  Future<String> fetchCurrentUserId() async {
    return "example_user_id";
  }

  Future<void> carlist() async {
    final docSnapshot = await _firestore
        .collection("machanices")
        .doc('HU42sidi1CzrfRC3dTFM')
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null && data['Machanics'] != null) {
        setState(() {
          carList = List<String>.from(data['Machanics']);
          filteredmechanic = carList; 
        });
      } else {
        print('Data or name field is null');
      }
    } else {
      print('Document does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe8f7fb),
      appBar: AppBar(
        title: const Center(child: Text('Select your Mechanic')),
        backgroundColor: const Color(0xFF519EB7),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: filteredmechanic.length,
                itemBuilder: (context, index) => GestureDetector(
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage('assets/machanic.png'),
                      ),
                      title: Text(
                        filteredmechanic[index],
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: const Text(
                          'Ratings: 4.5/5'), 
                      selected: selectedMechanic == filteredmechanic[index],
                      onTap: () {
                        setState(() {
                          selectedMechanic = filteredmechanic[index];
                          print('Selected mechanic:$Today ');
                          print('selectedtimeslot $selectedTimeSlotIndex');
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmAppointment(
                              selectedCarType: selectedCarType,
                              serviceType: servicetype,
                              Today: Today ?? DateTime.now(),
                              selectedTimeSlotIndex: selectedTimeSlotIndex,
                              selectedMechanic: selectedMechanic,
                            ), 
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
