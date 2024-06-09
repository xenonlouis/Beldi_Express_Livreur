import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Models/client.dart';

class ClientService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Client?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        return await _getClientData(user.uid);
      }
    } catch (e) {
      print("Error signing in: $e");
    }
    return null;
  }

  Future<Client?> _getClientData(String uid) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('Clients').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data != null) {
          return Client(
            id: uid,
            email: data['email'] ?? '',
            name: data['name'] ?? '',
            phone: data['phoneNumber'] ?? '',
            adresses: List<String>.from(data['addresses'] ?? []),
          );
        } else {
          print("Error: Document data is null");
        }
      } else {
        print("Error: Document does not exist");
      }
    } catch (e) {
      print("Error fetching client data: $e");
    }
    return null;
  }

  Future<Client?> registerWithEmailAndPassword(String email, String password, String name, String phoneNumber, String address) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        // Create a new document in the Clients collection with the user's ID
        await _firestore.collection('Clients').doc(user.uid).set({
          'email': email,
          'name': name,
          'phoneNumber': phoneNumber,
          'addresses': [address], // Store addresses as a list
        });
        // Fetch the client data
        return await _getClientData(user.uid);
      }
    } catch (e) {
      print("Error registering: $e");
      throw e;
    }
    return null;
  }
}
