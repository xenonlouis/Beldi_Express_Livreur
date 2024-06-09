
import 'package:dish_list/services/FirebaseServices.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'AuthenticationWrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WillPopScope(
        onWillPop: () async {

          print("ooooooooooooooooouuuuuuuuuuut");
          FirebaseServices().signOut();

          return true;
        },
        child: AuthenticationWrapper(),
      ),
    );
  }
}
