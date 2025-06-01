import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe8f7fb),
      appBar: AppBar(
        backgroundColor: const Color(0xFF519EB7),
        title: const Center(child: Text('User Appointments')),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildAppointmentsList('pending');
      case 1:
        return _buildAppointmentsList('completed');
      default:
        return Container();
    }
  }

  Widget _buildAppointmentsList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: status)
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
                    Text('User ID: ${data['userId']}'),
                    Text('Car Model: ${data['carModel']}'),
                    Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'), 
                    Text('Time Slot: ${data['timeSlot']}'),
                    Text('Mechanic: ${data['mechanic']}'),
                    Text('Appointment Time: ${data['appointmentTime']}'),
                    Text('Status: ${data['status']}'),
                    Text('Notes: ${data['notes'] ?? 'No notes'}'),
                    Text('Appointment Id: ${data['appointmentId']}'),
                    Text('Phone Number: ${data['PhoneNumber']}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    _markAsCompleted(snapshot.data!.docs[index].id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _markAsCompleted(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(documentId)
          .update({'status': 'completed'});
    } catch (e) {
      print('Error marking appointment as completed: $e');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminPage(),
  ));
}