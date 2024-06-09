
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/FirebaseServices.dart';
import '../services/FirestoreService.dart';

class UserInfoPage extends StatefulWidget {
  final FirestoreService firestoreService;
  UserInfoPage({Key? key, required this.firestoreService}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late Future<DocumentSnapshot<Object?>> infos;
  late final FirestoreService _firestoreService;
  late var userdata;

  @override
  void initState() {
    super.initState();
    _firestoreService = widget.firestoreService;
    infos =
        _firestoreService.getInfolivreur(FirebaseServices.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Object?>>(
      future: infos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          var userdata = snapshot.data!.data()! as Map<String, dynamic>;
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UID: ${snapshot.data!.id}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Name: ${userdata["name"]}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Email: ${userdata["email"]}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Phone: ${userdata["phone"]}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Region: ${userdata["reg"]}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showAddUserDialog(context, userdata, snapshot.data!.id);
                    },
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _showAddUserDialog(
      BuildContext context, Map<String, dynamic> userdetails, String id) {
    List<Widget> widgets = [];
    userdetails.forEach((key, valeur) {
      widgets.add(
        TextFormField(
          initialValue: valeur,
          decoration: InputDecoration(labelText: key),
          onChanged: (value) {
            userdetails[key] = value;
          },
        ),
      );
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firestoreService.updateInfoLivreur(id, userdetails);
                setState(() {
                  infos = _firestoreService.getInfolivreur(id);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
