import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Models/Fournisseur.dart';
import '../Models/dish.dart';
import 'dish_details.dart';

class FournisseurDetailsPage extends StatelessWidget {
  final Fournisseur fournisseur;

  const FournisseurDetailsPage({Key? key, required this.fournisseur})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          fournisseur.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(210, 0, 98, 51),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Email:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              fournisseur.email,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Phone Number:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              fournisseur.phoneNumber,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Address:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              fournisseur.address,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Dishes:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Dishes')!
                  .where(FieldPath.documentId, whereIn: fournisseur.dishIds)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // or any loading indicator
                }

                if (snapshot.data?.docs.isEmpty ?? true) {
                  // If there are no documents, don't display anything
                  return SizedBox.shrink();
                }
                return Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final Dish dish = Dish.fromJson(
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>,
                      );
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DishDetailsPage(dish: dish),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, right: 20.0, bottom: 10, left: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        dish.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          dish.name,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          dish.description,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          "${dish.price} DH",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Dish>> _getDishes(List<String> dishIds) async {
    List<Dish> dishes = [];
    for (String dishId in dishIds) {
      DocumentSnapshot dishSnapshot = await FirebaseFirestore.instance
          .collection('Dishes')
          .doc(dishId)
          .get();
      if (dishSnapshot.exists) {
        Dish dish = Dish.fromJson(dishSnapshot.data() as Map<String, dynamic>);
        dishes.add(dish);
      }
    }
    return dishes;
  }
}
