import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServiceHistory extends StatefulWidget {
  @override
  _UserServiceHistoryState createState() => _UserServiceHistoryState();
}

class _UserServiceHistoryState extends State<UserServiceHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe8f7fb),
      appBar: AppBar(
        backgroundColor: const Color(0xFF519EB7),
        title: Center(child: const Text('Service History')),
      ),
      body: _buildUserAppointmentsList(),
    );
  }

  Widget _buildUserAppointmentsList() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text('Please log in to view service history'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No service history available'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            DateTime date = (data['date'] as Timestamp).toDate(); 
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  'Service Type: ${data['serviceType']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Car Model: ${data['carModel']}'),
                    Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'), 
                    Text('Time Slot: ${data['timeSlot']}'),
                    Text('Mechanic: ${data['mechanic']}'),
                    Text('Appointment Time: ${data['appointmentTime']}'),
                    Text('Notes: ${data['notes'] ?? 'No notes'}'),
                    
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserServiceHistory(),
  ));
}
