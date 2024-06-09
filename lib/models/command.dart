import 'package:cloud_firestore/cloud_firestore.dart';

class Commande {
  final String id;
  final String id_client;
  final String id_fournisseur;
  final String id_livreur;
  final String address_liv; // Updated attribute
  final double price;
  final String status;
  final Map<String, Map<String, dynamic>> selected_dishes; // Updated attribute

  Commande({
    required this.id,
    required this.id_client,
    required this.id_fournisseur,
    required this.id_livreur,
    required this.address_liv, // Updated attribute
    required this.selected_dishes, // Updated attribute
    required this.price,
    required this.status,
  });

  factory Commande.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Commande(
      id: snapshot.id,
      id_client: data['id_client'],
      id_fournisseur: data['id_fournisseur'],
      id_livreur: data['id_livreur'],
      address_liv: data['address_liv'],
      selected_dishes: _parseSelectedDishes(data['selected_dishes'] ?? {}), // Updated attribute
      price: data['price']?.toDouble() ?? 0.0,
      status: data['status'],
    );
  }

  static Map<String, Map<String, dynamic>> _parseSelectedDishes(Map<String, dynamic> selectedDishesData) {
    Map<String, Map<String, dynamic>> parsedSelectedDishes = {};

    // Parse the selected dishes data
    selectedDishesData.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        parsedSelectedDishes[key] = value;
      }
    });

    return parsedSelectedDishes;
  }
}
