
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Models/Command.dart';
import '../Models/dishDTO.dart';
import '../services/firestore.dart';

class CommandsPage extends StatefulWidget {
  const CommandsPage({super.key});

  @override
  State<CommandsPage> createState() => _CommandListPageState();
}

class _CommandListPageState extends State<CommandsPage> {
  FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "Orders",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(240, 193, 39, 45),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getCommandsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No commands found.'));
          } else {
            List<Command> commands = snapshot.data!.docs
                .map((doc) =>
                    Command.fromJson(doc.data() as Map<String, dynamic>))
                .toList();

            commands.sort((a, b) {
              if (a.status == 'shipped' && b.status != 'shipped') {
                return 1;
              } else if (a.status != 'shipped' && b.status == 'shipped') {
                return -1;
              } else if (a.livreurId.isEmpty && b.livreurId.isNotEmpty) {
                return 1;
              } else if (a.livreurId.isNotEmpty && b.livreurId.isEmpty) {
                return -1;
              } else {
                return 0;
              }
            });

            return ListView.builder(
              itemCount: commands.length,
              itemBuilder: (context, index) {
                Command command = commands[index];
                return Card(
                  color: command.status == "shipped"
                      ? Color.fromARGB(255, 224, 224, 224)
                      : (command.livreurId == ''
                          ? Color.fromARGB(255, 255, 228, 76)
                          : Color.fromARGB(255, 124, 181, 112)),
                  elevation: 2,
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
                      );
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
        title: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "Your order",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(240, 193, 39, 45),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCommandInfoSection(),
            SizedBox(height: 20),
            _buildDishesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandInfoSection() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Command ID: ${command.id}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 193, 39, 45),
              ),
            ),
            SizedBox(height: 10),
            _buildCommandDetailRow('Client ID', command.clientId),
            _buildCommandDetailRow(
                'Livreur ID',
                command.livreurId.isEmpty
                    ? 'Not assigned yet'
                    : command.livreurId),
            _buildCommandDetailRow('Address', command.address),
            _buildCommandDetailRow('Status', command.status),
            _buildCommandDetailRow(
                'Total price', command.totalprice.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDishesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dishes:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Color.fromARGB(255, 193, 39, 45),
          ),
        ),
        SizedBox(height: 10),
        ...command.fournisseurDishes.entries.map((entry) {
          String fournisseurId = entry.key;
          List<DishDTO> dishes = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String?>(
                future:
                    FirestoreService().getFournisseurName(fournisseurId ?? ""),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error fetching fournisseur name');
                  } else {
                    String? fournisseurName = snapshot.data;
                    return Text(
                      "  ${fournisseurName ?? ''}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(210, 0, 98, 51),
                      ),
                    );
                  }
                },
              ),
              ...dishes.map((dish) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      dish.name,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text('Quantity: ${dish.quantity} ',
                            style: TextStyle(fontFamily: 'Poppins')),
                        ...dish.layers.map((layer) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${layer.layerName} : ${layer.options[0].optionName}',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            ],
                          );
                        }).toList(),
                        Text('Price: ${dish.price}',
                            style: TextStyle(fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        }).toList(),
      ],
    );
  }
}
