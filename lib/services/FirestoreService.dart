
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Commandee.dart';
import 'FirebaseServices.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String reg;
  bool _isRegInitialized = false;

  FirestoreService() {
    _initializeRegIfNeeded();
  }

  Future<void> _initializeRegIfNeeded() async {
    if (!_isRegInitialized) {
      await _initializeReg();
      _isRegInitialized = true;
    }
  }

  Future<void> _initializeReg() async {
    String livid = FirebaseServices.uid;
    DocumentSnapshot livreurSnapshot = await FirebaseFirestore.instance
        .collection('livreurs')
        .doc(livid)
        .get();
    reg = livreurSnapshot.get('reg') ?? '';
    print(reg);
  }



  // Fetch all commands from the Firestore collection
  Future<List<Command>> getCommandsav() async {
    try {
      await _initializeRegIfNeeded();
    
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Commandes')
          .where('livreurId', isEqualTo: '')
          .where('region', isEqualTo: reg)
          .get();
      List<Command> commands =
          snapshot.docs.map((doc) => Command.fromJson(doc.data())).toList();
      return commands;
    } catch (e) {
      print('Error fetching commands: $e');
      return [];
    }
  }

  Future<List<Command>> getCommandspen() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Commandes')
          .where('status', whereIn: ['preparing','on the way'])
          .where('livreurId', isNotEqualTo: '')
          .where('region', isEqualTo: reg)
          .get();
      List<Command> commands =
          snapshot.docs.map((doc) => Command.fromJson(doc.data())).toList();
      return commands;
    } catch (e) {
      print('Error fetching commands: $e');
      return [];
    }
  }
  Future<List<Command>> getCommandsship() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Commandes')
          .where('status', isEqualTo: 'shipped')
          .where('region', isEqualTo: reg)
          .get();
      List<Command> commands =
          snapshot.docs.map((doc) => Command.fromJson(doc.data())).toList();
      return commands;
    } catch (e) {
      print('Error fetching commands: $e');
      return [];
    }
  }

  // Update the livreurId for a command
  Future<void> setLivreurId(String commandId, String livreurId) async {
    try {
      await _firestore.collection('Commandes').doc(commandId).update({
        'livreurId': livreurId,
        'status': 'preparing',
      });
    } catch (e) {
      print('Error updating livreurId: $e');
    }
  }

  Future<void> updatestatus(String commandId, String status) async {
    String newstat = 'shipped';
    if (status == "preparing") {
      newstat = "on the way";
    }else if (status == "on the way") {
      newstat = "shipped";
    }
    try {
      await _firestore.collection('Commandes').doc(commandId).update({
        'status': newstat,
      });
    } catch (e) {
      print('Error updating livreurId: $e');
    }
  }


  Future<String> getclientname(String id) async {
    DocumentSnapshot<Object?> documentSnapshot =
        await FirebaseFirestore.instance.collection('clients').doc(id).get();
    return documentSnapshot.data() as String;
  }

  Future<DocumentSnapshot<Object?>> getInfolivreur(String id) async {
    DocumentSnapshot<Object?> documentSnapshot =
        await FirebaseFirestore.instance.collection('livreurs').doc(id).get();
    return documentSnapshot;
  }

  Future<void> updateInfoLivreur(String userId, Map<String, dynamic> updatedInfo) async {
    try {
      await FirebaseFirestore.instance.collection('livreurs').doc(userId).update(updatedInfo);
    } catch (e) {
      print('Error updating user info: $e');
      throw e;
    }
  }
}
