import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('livreurs');

  static String uid = _auth.currentUser!.uid;

  Future<User?> registerWithEmailAndPassword(String email, String password,
      String name, String phone, String reg) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uuid = userCredential.user!.uid;
      await _usersCollection
          .doc(uuid)
          .set({'name': name, 'email': email, 'phone': phone, 'reg': reg});
      uid = uuid;
      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      String uuid = userCredential.user!.uid;
      uid = uuid;
      // Check if user exists in Firestore
      DocumentSnapshot userDoc =
          await _usersCollection.doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        print("bad credentials");
        //throw FirebaseAuthException(
        //  code: 'user-not-found',
        //message: 'No user found with this email. Please register first.');
      }

      return userCredential.user;
    } catch (e) {
      throw e;
    }
  }

  String getCurrentUserid() {
    String uid = _auth.currentUser!.uid;
    return uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
