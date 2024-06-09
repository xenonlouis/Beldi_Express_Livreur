
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../Models/Fournisseur.dart';
import '../Models/dish.dart';
import 'Cart_Page.dart';
import 'Favourites_page.dart';
import 'dish_details.dart';
import 'fournisseur_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Light beige background
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "Beldi Express",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavouritePage(),
                ),
              ),
            },
            icon: const Icon(CupertinoIcons.heart_fill, color: Colors.white),
          ),
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              ),
            },
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
          ),
        ],
        backgroundColor: Color.fromARGB(240, 193, 39, 45), // Moroccan red
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "Popular",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 193, 39, 45),
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Dishes')
                      .limit(5)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
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
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return SizedBox(
                      height: 270,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var dish = Dish.fromJson(snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>);
                          dish =
                              dish.copyWith(id: snapshot.data!.docs[index].id);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DishDetailsPage(dish: dish),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 15),
                              width: 180,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.white,
                                elevation: 5,
                                shadowColor: Colors.black26,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          dish.imageUrl,
                                          width: 150,
                                          height: 130,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              5), // Adjusted height or removed SizedBox
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          dish.name,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          dish.description,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          "${dish.price} DH",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
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
                SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Fournisseurs')
                      .limit(5)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Something went wrong',
                              style: TextStyle(fontFamily: 'Poppins')));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Restaurants",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(255, 193, 39, 45),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final Fournisseur fournisseur = Fournisseur(
                                id: snapshot.data!.docs[index].id,
                                email: snapshot.data!.docs[index]['email'],
                                name: snapshot.data!.docs[index]['name'],
                                phoneNumber: snapshot.data!.docs[index]
                                    ['phoneNumber'],
                                dishIds: List<String>.from(
                                    snapshot.data!.docs[index]['dishIds']),
                                address: snapshot.data!.docs[index]['address'],
                              );
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FournisseurDetailsPage(
                                              fournisseur: fournisseur),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                        210, 0, 98, 51), // Moroccan green
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      fournisseur.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "New in",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 193, 39, 45),
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Dishes')
                      .limit(10)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Something went wrong',
                              style: TextStyle(fontFamily: 'Poppins')));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
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

class FavB extends StatefulWidget {
  const FavB({Key? key}) : super(key: key);

  @override
  State<FavB> createState() => _FavBState();
}

class _FavBState extends State<FavB> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isFav = !isFav;
        });
      },
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: Color(0xffFF5F99),
        size: 24.0,
      ),
    );
  }
}
