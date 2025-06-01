
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser({
    required String userName,
    required String email,
    required String phoneNumber,
     required String uid,
  }) async {
    try {
      await usersCollection.add({
        'userName': userName,
        'email': email,
        'phoneNumber': phoneNumber,
         'uid': uid,
      });
      
    } catch (e) {
      print('Error adding user to Firestore: $e');
      // Handle error as needed
    }
  }
}
