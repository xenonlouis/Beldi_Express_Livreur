import 'package:cloud_firestore/cloud_firestore.dart';

class Livreur {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String reg;

  Livreur({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.reg,
  });

  factory Livreur.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Livreur(
      id: snapshot.id,
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      reg: data['reg']
    );
  }
}