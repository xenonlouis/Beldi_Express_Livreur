
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Commandee.dart';
import '../models/dishDTO.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _saveDataToFirestore() async {
    List<Command> mockCommands = [
      Command(
        id: '1',
        address: '123 Main St',
        clientId: 'client1',
        livreurId: '',
        region: 'Region 1',
        status: '',
        fournisseurDishes: {
          'fournisseur1': [
            DishDTO(id: 'dish1', name: 'Dish 1', price: 10, layers: [], quantity: 1),
            DishDTO(id: 'dish2', name: 'Dish 2', price: 15, layers: [], quantity: 1),
          ],
          'fournisseur2': [
            DishDTO(id: 'dish3', name: 'Dish 3', price: 20, layers: [], quantity: 1),
            DishDTO(id: 'dish4', name: 'Dish 4', price: 25, layers: [], quantity: 1),
          ],
        },
        statusDishes: {'fournisseur1':'',
        'fournisseur2':''},
        fournisseurIDs: ['fournisseur1', 'fournisseur2'],
      ),
      Command(
        id: '2',
        address: '456 Oak St',
        clientId: 'client2',
        livreurId: '',
        region: 'Region 2',
        status: '',
        fournisseurDishes: {
          'fournisseur1': [
            DishDTO(id: 'dish5', name: 'Dish 5', price: 30, layers: [], quantity: 1),
            DishDTO(id: 'dish6', name: 'Dish 6', price: 35, layers: [], quantity: 1),
          ],
          'fournisseur2': [
            DishDTO(id: 'dish7', name: 'Dish 7', price: 40, layers: [], quantity: 1),
            DishDTO(id: 'dish8', name: 'Dish 8', price: 45, layers: [], quantity: 1),
          ],
        },
        statusDishes: {'fournisseur1':'',
        'fournisseur2':''},
        fournisseurIDs: ['fournisseur1', 'fournisseur2'],
      ),
    ];

    // Save mock commands to Firestore
    for (Command command in mockCommands) {
      try {
        await saveCommand(command, firestore);
        print('Command ${command.id} saved successfully.');
      } catch (e) {
        print('Error saving command ${command.id}: $e');
      }
    }
  }

  // Function to save a command to Firestore
  Future<void> saveCommand(Command command, FirebaseFirestore firestore) async {
    // Convert Command object to JSON
    Map<String, dynamic> commandJson = command.toJson();

    // Add the command to Firestore
    await firestore.collection('Commandes').doc(command.id).set(commandJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Test App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _saveDataToFirestore,
          child: Text('Save Data to Firestore'),
        ),
      ),
    );
  }
}