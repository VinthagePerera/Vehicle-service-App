import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCarsPage extends StatefulWidget {
  const MyCarsPage({Key? key}) : super(key: key);

  @override
  _MyCarsPageState createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  TextEditingController searchController = TextEditingController();
  List<String> carList = []; 
  List<String> filteredCarList = []; 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? currentUserId; 
  @override
  void initState() {
    super.initState();
    carlist();
    getCurrentUserId();
  }

  void getCurrentUserId() async {
    currentUserId = await fetchCurrentUserId();
    setState(() {});
  }

  Future<String> fetchCurrentUserId() async {
    return "example_user_id"; 
  }

  Future<void> carlist() async {
    final docSnapshot =
        await _firestore.collection("cars").doc('JzgjYUlWMWcpSPSIpUF5').get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null && data['name'] != null) {
        setState(() {
          carList = List<String>.from(data['name']);
          filteredCarList = carList; 
        });
      } else {
        print('Data or name field is null');
      }
    } else {
      print('Document does not exist');
    }
  }

  void filterCars(String query) {
    setState(() {
      filteredCarList = carList
          .where((car) => car.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> addToUserCars(String carModel) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("Error: Current user not authenticated");
    return;
  }

  try {
    final userQuerySnapshot = await _firestore
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .get();

    if (userQuerySnapshot.docs.isNotEmpty) {
      final userDocumentReference = userQuerySnapshot.docs.first.reference;

      await userDocumentReference.update({
        'userCars': FieldValue.arrayUnion([carModel])
      });
    } else {
      print("User document not found");
    }
  } catch (e) {
    print("Error adding car to user's cars: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe8f7fb),
      appBar: AppBar(
        title: Center(child: const Text('Search Cars')),
        backgroundColor: Color(0xFF519EB7),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search for a car...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                filterCars(value);
              },
              onSubmitted: (value) {},
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: filteredCarList.length,
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(filteredCarList[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await addToUserCars(filteredCarList[index]);
                          },
                          child: const Text('Add'),
                        ),
                      ],
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
