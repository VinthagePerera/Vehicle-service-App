import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static const String adminEmail = 'admin12@gmail.com';
  static const String adminPassword = 'admin123';

  static Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
    required Function onError,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      if (userCredential.user != null &&
          email == adminEmail &&
          password == adminPassword) {
        Navigator.pushReplacementNamed(context, '/Admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}
