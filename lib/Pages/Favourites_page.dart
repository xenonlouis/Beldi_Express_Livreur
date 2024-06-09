
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/dish.dart';
import '../services/firestore.dart';
import 'dish_details.dart';

class FavouritePage extends StatefulWidget {
  FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final FirestoreService _firestoreService = FirestoreService();
  Stream<QuerySnapshot<Object?>>? favlist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    favlist = _firestoreService.getFavouriteDishes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Light beige background
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "Your favorite dishes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(240, 193, 39, 45), // Moroccan red
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: favlist,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Something went wrong',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No favourite dishes found',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Dish dish = Dish.fromJson(snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>);
                        dish = dish.copyWith(id: snapshot.data!.docs[index].id);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DishDetailsPage(dish: dish),
                                ),
                              ).then((value) {
                                setState(() {
                                  favlist =
                                      _firestoreService.getFavouriteDishes();
                                });
                              });
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0,
                                    right: 20.0,
                                    bottom: 10,
                                    left: 10),
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
                                            offset: const Offset(0, 3),
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
                                          const SizedBox(height: 10),
                                          Text(
                                            dish.name,
                                            style: const TextStyle(
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
                                            style: const TextStyle(
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
