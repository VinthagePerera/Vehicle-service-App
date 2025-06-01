import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/components/label.dart';
import 'package:project1/components/my-text%20_field.dart';
import 'package:project1/userregister.dart';

class Personal_Info extends StatefulWidget {
  Personal_Info({super.key});

  @override
  State<Personal_Info> createState() => _Personal_InfoState();
}

class _Personal_InfoState extends State<Personal_Info> {
  final user_name = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpass = TextEditingController();
  final phonenumber = TextEditingController();
  

  final firestoreService = FirestoreService();

  Future<void> registerUser(BuildContext context) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailcontroller.text.trim(),
      password: passwordcontroller.text.trim(),
    );
    print('User registered successfully: ${userCredential.user!.email}');

    await firestoreService.addUser(
      userName: user_name.text.trim(),
      email: emailcontroller.text.trim(),
      phoneNumber: phonenumber.text.trim(),
      uid: userCredential.user!.uid,
    );

    Navigator.pushReplacementNamed(context, '/home');
  } catch (e) {
    // Handle registration errors
    print('Error registering user: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to register user: $e'),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF519EB7),
          title: const Center(
            child: Text(
              'Personal Details',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.only(top: 13, bottom: 14),
                      child: Text('Personal Details',
                          style: TextStyle(
                              fontSize: 32, color: Color(0xFF1D4BA6))))),
              const Label(text: 'User Name'),
              My_text_feild(
                hintText: 'User Name',
                controller: user_name,
              ),
              const SizedBox(
                height: 9,
              ),
              const Label(text: 'Email'),
              My_text_feild(
                hintText: 'Email',
                controller: emailcontroller,
              ),
              const SizedBox(
                height: 9,
              ),
              const Label(text: 'Password'),
              My_text_feild(
                hintText: 'Password',
                controller: passwordcontroller,
              ),
              const SizedBox(
                height: 9,
              ),
              const Label(text: 'Confirm Password'),
              My_text_feild(
                hintText: 'Confirm Password',
                controller: confirmpass,
              ),
              const SizedBox(
                height: 9,
              ),
              const Label(text: 'Phone Number'),
              My_text_feild(
                hintText: 'phone Number',
                controller: phonenumber,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () => registerUser(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF130E4E),
                      fixedSize: const Size(223, 56)),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
