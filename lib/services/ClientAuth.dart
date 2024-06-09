import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dish_list/Models/client.dart';

class UserProfileProvider with ChangeNotifier {
  late Client _userProfile;
  late FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Client get userProfile => _userProfile;

  UserProfileProvider() {
    _fetchUserProfile();
  }
  void update() {_fetchUserProfile();}


  Future<void> _fetchUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final snapshot = await _firestore.collection('Clients').doc(currentUser.uid).get();
        final userData = snapshot.data() as Map<String, dynamic>;
        _userProfile = Client(
          id: currentUser.uid,
          email: currentUser.email ?? '',
          name: userData['name'] ?? '',
          phone: userData['phoneNumber'] ?? '',
          adresses: List<String>.from(userData['addresses'] ?? []),
        );
        await Future.delayed(Duration(milliseconds: 25));
        notifyListeners();
      } catch (e) {
        print('Error fetching user profile: $e');
      }
    }
  }

  Future<void> updateUserProfile(String userId, String newEmail, List<String> newAddresses, String newName, String newPhone) async {
    try {
      // Get a reference to the user profile document in Firestore
      final userDocRef = FirebaseFirestore.instance.collection('Clients').doc(userId);

      // Update the fields in the document
      await userDocRef.update({
        'email': newEmail,
        'addresses': newAddresses,
        'name': newName,
        'phoneNumber': newPhone,
      });
      notifyListeners();

      print('User profile updated in the database');
    } catch (e) {
      print('Error updating user profile in the database: $e');
      throw e; // Optionally rethrow the error to handle it elsewhere
    }
  }
}
