// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../models/Commandee.dart';
import '../models/dishDTO.dart';
import '../services/FirestoreService.dart';

class CommandshippedPage extends StatefulWidget {
  final FirestoreService firestoreService;
  const CommandshippedPage({super.key, required this.firestoreService});

  @override
  State<CommandshippedPage> createState() => _CommandListPageState();
}

class _CommandListPageState extends State<CommandshippedPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Command>>(
        future: widget.firestoreService.getCommandsship(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Command>? commands = snapshot.data;
            return ListView.builder(
              itemCount: commands!.length,
              itemBuilder: (context, index) {
                Command command = commands[index];
                return Card(
                  elevation: 2, // Adding elevation for a modern card effect
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    title: Text('Command ID: ${command.id}'),
                    subtitle: Text('Address: ${command.address}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CommandDetailsPage(command: command),
                        ),
                      ).then((_) {
                        setState(() {});
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CommandDetailsPage extends StatelessWidget {
  final Command command;
  final FirestoreService firestoreService = FirestoreService();

  CommandDetailsPage({required this.command});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Command Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Command ID: ${command.id}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Client ID: ${command.clientId}'),
            Text('Livreur ID: ${command.livreurId}'),
            Text('Address: ${command.address}'),
            Text('Region: ${command.region}'),
            Text('Status: ${command.status}'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: command.statusDishes.keys.map((entry) {
                String fournisseurId = entry;
                String? stat = command.statusDishes[entry];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '$fournisseurId: $stat',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Dishes:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: command.fournisseurDishes.entries.map((entry) {
                String fournisseurId = entry.key;
                List<DishDTO> dishes = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Fournisseur ID: $fournisseurId',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: dishes.map((dish) {
                        return ListTile(
                          title: Text('Dish name: ${dish.name}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: ${dish.quantity}'),
                              Text('Price: ${dish.price}'),
                              // Display other dish details as needed
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
