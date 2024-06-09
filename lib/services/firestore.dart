import 'package:client_app/services/FirebaseServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  final String uid = FirebaseServices.uid;
  String uid = FirebaseServices.uid;

  Future<String?> getFournisseurName(String fournisseurId) async {
    try {
      // Get the document snapshot for the provided fournisseurId
      DocumentSnapshot fournisseurSnapshot =
          await _firestore.collection('Fournisseurs').doc(fournisseurId).get();

      // Check if the document exists
      if (fournisseurSnapshot.exists) {
        // Get the name field from the snapshot data
        return fournisseurSnapshot.get('name');
      } else {
        // If the document does not exist, return null or handle accordingly
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error getting fournisseur name: $e');
      return null;
    }
  }

  Stream<QuerySnapshot> getCommandsStream() {
    return _firestore
        .collection('Commandes')
        .where('clientId', isEqualTo: uid)
        .snapshots();
  }

  Future<bool> isDishIdInList(String userId, String? dishId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Clients')
          .where(FieldPath.documentId, isEqualTo: userId)
          .where('favourites', arrayContains: dishId)
          .get();

      print(querySnapshot);

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error querying document: $e');
      return false;
    }
  }

  Future<void> updateFavoriteDish(
      String userId, String? dishId, bool isFavorite) async {
    final userDoc =
        FirebaseFirestore.instance.collection('Clients').doc(userId);

    if (isFavorite) {
      // Add the dishId to the favorites array
      await userDoc.update({
        'favourites': FieldValue.arrayUnion([dishId]),
      });
    } else {
      // Remove the dishId from the favorites array
      await userDoc.update({
        'favourites': FieldValue.arrayRemove([dishId]),
      });
    }
  }

  Stream<QuerySnapshot<Object?>>? getFavouriteDishes() async* {
    // Step 1: Get the user document
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Clients').doc(uid).get();

    // Step 2: Retrieve the 'favourites' array
    List<dynamic> favourites = userDoc.get('favourites') ?? [];

    // Step 3: If there are no favourites, return an empty stream
    if (favourites.isEmpty) {
      yield* Stream<QuerySnapshot<Object?>>.empty();
    } else {
      // Step 4: Query the 'Dishes' collection to get the dishes in the favourites array
      yield* FirebaseFirestore.instance
          .collection('Dishes')
          .where(FieldPath.documentId, whereIn: favourites)
          .snapshots();
    }
  }
}
