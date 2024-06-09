import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import the Firestore package
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class Dish {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> ingredients;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.ingredients,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      ingredients: List<String>.from(json['ingredients']),
    );
  }
}

List<Dish> mockMoroccanDishes = [
  Dish(
    id: '1',
    name: 'Tagine',
    description: 'A traditional Moroccan stew cooked in a clay pot with various ingredients, such as chicken, lamb, vegetables, and spices.',
    price: 15.99,
    ingredients: ['Chicken', 'Lamb', 'Vegetables', 'Spices'],
  ),
  Dish(
    id: '2',
    name: 'Couscous',
    description: 'A staple Moroccan dish made from steamed semolina grains, often served with a stew of meat and vegetables.',
    price: 12.99,
    ingredients: ['Semolina', 'Meat', 'Vegetables', 'Spices'],
  ),
  Dish(
    id: '3',
    name: 'Pastilla (B\'stilla)',
    description: 'A savory Moroccan pastry filled with spiced meat (usually pigeon or chicken), almonds, and eggs, topped with powdered sugar and cinnamon.',
    price: 18.99,
    ingredients: ['Pigeon or Chicken', 'Almonds', 'Eggs', 'Spices'],
  ),
  Dish(
      id: '4',
      name: 'Harira',
      description: 'A traditional Moroccan soup made from a blend of lentils, chickpeas, tomatoes, and spices, often served during Ramadan.',
      price: 9.99,
      ingredients: ['Lentils', 'Chickpeas', 'Tomatoes', 'Spices']
  ),
  Dish(
    id: '5',
    name: 'Mechoui',
    description: 'A festive Moroccan dish consisting of whole roasted lamb or sheep, seasoned with a blend of spices, often served at special occasions and celebrations.',
    price: 24.99,
    ingredients: ['Lamb or Sheep', 'Spices'],
  ),
];

Future<void> pushDishesToFirestore(List<Dish> dishes) async {
  // Get a reference to the Firestore collection
  final CollectionReference dishesCollection = FirebaseFirestore.instance.collection('dishes');

  for (var dish in dishes) {
    try {
      // Add each dish to the Firestore collection
      await dishesCollection.add({
        'id': dish.id,
        'name': dish.name,
        'description': dish.description,
        'price': dish.price,
        'ingredients': dish.ingredients,
      });
      print('Dish ${dish.name} added to Firestore');
    } catch (error) {
      print('Failed to add dish ${dish.name}: $error');
      // Re-throw the error to propagate it to the caller
      rethrow;
    }
  }
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Firebase Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              try {
                pushDishesToFirestore(mockMoroccanDishes);
              } catch (e) {
                // Handle the error
                print('Error: $e');
              }
            },
            child: const Text('Push Data to Firebase'),
          ),
        ),
      ),
    );
  }
}
