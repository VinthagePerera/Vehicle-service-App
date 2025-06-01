import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/components/my_buttons.dart';
import 'package:project1/components/spacer.dart';

class ConfirmAppointment extends StatefulWidget {
  final String? selectedCarType;
  final String? serviceType;
  final String? selectedTimeSlotIndex;
  final String? selectedMechanic;
  final DateTime Today;

  const ConfirmAppointment({
    Key? key,
    required this.selectedCarType,
    required this.serviceType,
    required this.selectedTimeSlotIndex,
    required this.selectedMechanic,
    required this.Today,
  }) : super(key: key);

  @override
  State<ConfirmAppointment> createState() => _ConfirmAppointmentState();
}

class _ConfirmAppointmentState extends State<ConfirmAppointment> {
  late BuildContext _context;
  late String selectedMechanic;
  late DateTime today;
  late String appointmentTime;
  final TextEditingController _notesController = TextEditingController();
  late String? userPhoneNumber;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    today = widget.Today;
    appointmentTime = '${today.hour}:${today.minute}';
    selectedMechanic = widget.selectedMechanic ?? '';
    _context = context;
    print('selected date:$today');
  }

  Future<void> _getUserPhoneNumber() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Query Firestore to get user's phone number
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: user.uid)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();
        setState(() {
          userPhoneNumber = userData['phoneNumber'];
        });
      }
    }
  }


  Future<void> _submitAppointment() async {
    await _getUserPhoneNumber();
    
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    String carModel = widget.selectedCarType ?? '';
    String serviceType = widget.serviceType ?? '';
    String mechanic = widget.selectedMechanic ?? '';
    String? timeSlotIndex = widget.selectedTimeSlotIndex;

    try {
      DocumentSnapshot<Map<String, dynamic>> counterDoc =
          await FirebaseFirestore.instance
              .collection('counters')
              .doc('appointments')
              .get();

      int currentAppointmentId = counterDoc.exists
          ? (counterDoc.data()!['appointmentId'] ?? 0) as int
          : 0;

      int newAppointmentId = currentAppointmentId + 1;

      await FirebaseFirestore.instance.collection('appointments').add({
        'userId': user.uid,
        'appointmentId': newAppointmentId.toString(),
        'carModel': carModel,
        'date': today,
        'timeSlot': timeSlotIndex,
        'serviceType': serviceType,
        'mechanic': mechanic,
        'appointmentTime': appointmentTime,
        'status': 'pending',
        'PhoneNumber':userPhoneNumber,
        'notes': _notesController.text,
      });

      await FirebaseFirestore.instance
          .collection('counters')
          .doc('appointments')
          .set({
        'appointmentId': newAppointmentId,
      });

      ScaffoldMessenger.of(_context).showSnackBar(
        const SnackBar(
          content: Text('Appointment submitted successfully!'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error submitting appointment: $e');
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text('Error submitting appointment: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe8f7fb),
      appBar: AppBar(
        backgroundColor: const Color(0xFF519EB7),
        title: const Text('Confirm Booking'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(width: 16.0),
                  Text(
                    'Mechanic Details',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/machanic.png'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '$selectedMechanic',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  const Text(
                    'Ratings: 4.5/5',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              thickness: 5,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Booking Summary',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Space(text: 'Service Type', secondText: '${widget.serviceType}'),
            Space(text: 'Create Date', secondText: '$today'),
            Space(text: 'Appointment Time', secondText: appointmentTime),
            Space(text: 'Vehicle', secondText: '${widget.selectedCarType}'),
            const Space(text: 'Service Cost', secondText: 'LKR 3000'),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              thickness: 5,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Additional Notes',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Type any note you need to send to the mechanic',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              thickness: 5,
            ),
            Center(
              child: My_Buttons(
                text: 'Confirm Booking',
                size: 30,
                onpressed: _submitAppointment,
              ),
            )
          ],
        ),
      ),
    );
  }
}
