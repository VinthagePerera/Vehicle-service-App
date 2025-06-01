 

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/Admin_screens/admin.dart';
import 'package:project1/Page1.dart';
import 'package:project1/login.dart';
import 'package:project1/mainhome.dart';
import 'package:project1/personal_info.dart';
import 'firebase_options.dart';

import 'dart:io';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ?

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCb5XBDca1HFbSXKmcrwNoXku6Fdvz8474",
          appId: "1:74337324883:android:e6ca77742c356b1b689ba6",
          messagingSenderId: "74337324883",
          projectId: "car-service-app-a3cb2")):
          await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  

  runApp(const Page());
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  Page1(),
      routes: <String, WidgetBuilder>{'/login': (context) =>  Login(),
      '/home': (context) =>   Mainhome(),
      '/perinfo': (context) =>   Personal_Info(),
      '/Admin': (context) =>   AdminPage(),

      
   },
    );
  }
}
