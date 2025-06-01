import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateProfile({
  required TextEditingController userNameController,
  required TextEditingController emailController,
  required TextEditingController phoneNumberController,
  required BuildContext context,
}) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: user.uid)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> userDocument =
            querySnapshot.docs.first;
        await userDocument.reference.update({
          'userName': userNameController.text.trim(),
          'email': emailController.text.trim(),
          'phoneNumber': phoneNumberController.text.trim(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Center(child: Text('Profile updated successfully'))));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User profile not found')));
      }
    }
  } catch (e) {
    print('Error updating user profile: $e');
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')));
  }
}
