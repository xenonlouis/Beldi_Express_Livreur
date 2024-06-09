import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Fournisseur.dart';
import '../Models/dish.dart';
import 'dish_details.dart';
import 'fournisseur_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Map<String, dynamic>>> searchResults;
  final TextEditingController _searchController = TextEditingController();
  String searchType = 'dish'; // Initialize search type

  @override
  void initState() {
    super.initState();
    searchResults = _getSearchResults("test");
  }

  Future<List<Map<String, dynamic>>> _getSearchResults(String prefix) async {
    if (prefix == "test") {
      return [];
    }

    if (searchType == 'dish') {
      QuerySnapshot<Map<String, dynamic>> dishesSnapshot =
          await FirebaseFirestore.instance
              .collection('Dishes')
              .where('name', isGreaterThanOrEqualTo: prefix)
              .where('name', isLessThan: '$prefix\uf7ff')
              .get();

      List<Map<String, dynamic>> results = [];

      // Group dishes by fournisseur id
      Map<String, List<Dish>> groupedResults = {};

      dishesSnapshot.docs.forEach((dishDoc) {
        Dish dish = Dish.fromJson(dishDoc.data());
        if (!groupedResults.containsKey(dish.idfournisseur)) {
          groupedResults[dish.idfournisseur!] = [];
        }
        groupedResults[dish.idfournisseur!]!.add(dish);
      });

      // Fetch details of each fournisseur
      await Future.forEach(groupedResults.keys, (fournisseurId) async {
        DocumentSnapshot fournisseurDoc = await FirebaseFirestore.instance
            .collection('Fournisseurs')
            .doc(fournisseurId)
            .get();

        Map<String, dynamic>? fournisseurData =
            fournisseurDoc.data() as Map<String, dynamic>?;

        Fournisseur fournisseur = Fournisseur.fromJson(fournisseurData ?? {});

        // Add fournisseur details and dishes to the results list
        results.add({
          'fournisseur': fournisseur,
          'dishes': groupedResults[fournisseurId],
        });
      });
      return results;
    } else {
      QuerySnapshot<Map<String, dynamic>> fournisseursSnapshot =
          await FirebaseFirestore.instance
              .collection('Fournisseurs')
              .where('name', isGreaterThanOrEqualTo: prefix)
              .where('name', isLessThan: '$prefix\uf7ff')
              .get();

      List<Map<String, dynamic>> results = fournisseursSnapshot.docs.map((doc) {
        Fournisseur fournisseur = Fournisseur.fromJson(doc.data());
        print(fournisseur.name);
        return {'fournisseur': fournisseur};
      }).toList();

      return results;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "Search",
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          searchType = 'dish';
                          searchResults = _getSearchResults(
                              (_searchController.text == ""
                                  ? "test"
                                  : _searchController.text));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: searchType == 'dish'
                            ? Color.fromARGB(255, 127, 187, 123)
                            : Color.fromARGB(255, 216, 216, 216),
                      ),
                      child: Text(
                        'Search Dish',
                        style:
                            TextStyle(color: Color.fromARGB(255, 43, 43, 43)),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          searchType = 'supplier';
                          searchResults = _getSearchResults(
                              (_searchController.text == ""
                                  ? "test"
                                  : _searchController.text));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: searchType == 'supplier'
                            ? Color.fromARGB(255, 127, 187, 123)
                            : Color.fromARGB(255, 216, 216, 216),
                      ),
                      child: Text('Search Supplier',
                          style: TextStyle(
                              color: Color.fromARGB(255, 43, 43, 43))),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by name...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchResults =
                        _getSearchResults((value == "" ? "test" : value));
                  });
                },
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                List<Map<String, dynamic>> results = snapshot.data ?? [];

                return Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      List<Map<String, dynamic>> results = snapshot.data ?? [];
                      if (searchType == 'dish') {
                        Fournisseur fournisseur = results[index]['fournisseur'];
                        List<Dish> dishes = results[index]['dishes'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                fournisseur.name,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(210, 0, 98, 51)),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dishes.length,
                              itemBuilder: (context, index) {
                                Dish dish = dishes[index];
                                // Display dish details here
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
                            ),
                          ],
                        );
                      } else {
                        Fournisseur fournisseur = results[index]['fournisseur'];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, right: 20.0, bottom: 10, left: 10),
                            child: ListTile(
                              title: Text(
                                fournisseur.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(210, 0, 98, 51),
                                ),
                              ),
                              subtitle: Text(
                                fournisseur
                                    .address, // Assuming you have an 'address' property in your Fournisseur model
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FournisseurDetailsPage(
                                      fournisseur: fournisseur,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
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
}
