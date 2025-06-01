import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/updateuserdata.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? userNameController;
  TextEditingController? emailController;
  TextEditingController? phoneNumberController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: user.uid)
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          var docSnapshot = querySnapshot.docs.first;

          setState(() {
            userNameController =
                TextEditingController(text: docSnapshot['userName']);
            emailController =
                TextEditingController(text: docSnapshot['email']);
            phoneNumberController =
                TextEditingController(text: docSnapshot['phoneNumber']);
            isLoading = false;
          });
        } else {
          print('User document does not exist');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('User is not authenticated');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  void updateUserProfile() async {
    
    await updateProfile(
      userNameController: userNameController!,
      emailController: emailController!,
      phoneNumberController: phoneNumberController!,
      context: context,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFe8f7fb),
        appBar: AppBar(
          backgroundColor: const Color(0xFF519EB7),
          title: const Center(child: Text('Profile Info')),
        ),
        body: SafeArea(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 3,
                            ),
                          ),
                          Text(
                            'User Details',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF422C82),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 3,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            TextField(
                              controller: userNameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: phoneNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF130E4E)
                              ),
                              onPressed: updateUserProfile,
                              child: const Text('Update Profile',
                              style: TextStyle(
                                color: Colors.white
                              ),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
