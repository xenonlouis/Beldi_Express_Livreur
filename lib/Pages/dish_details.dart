
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Models/Layer.dart';
import '../Models/cart_model.dart';
import '../Models/dish.dart';
import '../services/FirebaseServices.dart';
import '../services/firestore.dart';

// ignore: must_be_immutable
class DishDetailsPage extends StatefulWidget {
  late Dish dish;

  DishDetailsPage({super.key, required this.dish});

  @override
  _DishDetailsPageState createState() => _DishDetailsPageState();
}

class _DishDetailsPageState extends State<DishDetailsPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late Map<String, Option?> selectedOptions;
  final cart = CartModel(); // Accessing the singleton cart model
  int quantity = 1;
  late Future<bool> isfav;
  late Future<String?> fname;

  @override
  void initState() {
    super.initState();
    selectedOptions = {};
    widget.dish.layers.forEach((layer) {
      selectedOptions[layer.layerName] = layer.options.first;
    });
    isfav =
        _firestoreService.isDishIdInList(FirebaseServices.uid, widget.dish.id);
    fname =
        _firestoreService.getFournisseurName(widget.dish.idfournisseur ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.dish.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(240, 193, 39, 45),
          actions: [
            FutureBuilder<bool>(
              future: isfav,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Visibility(
                    child: Text("Invisible"),
                    visible: false,
                  );
                } else if (snapshot.hasData && snapshot.data!) {
                  return IconButton(
                    onPressed: () => {
                      setState(() {
                        isfav = flipFutureBool(isfav);
                        _firestoreService.updateFavoriteDish(
                            FirebaseServices.uid, widget.dish.id, false);
                      })
                    },
                    icon: const Icon(CupertinoIcons.heart_fill,
                        color: Colors.white),
                  );
                } else {
                  return IconButton(
                    onPressed: () => {
                      setState(() {
                        isfav = flipFutureBool(isfav);
                        _firestoreService.updateFavoriteDish(
                            FirebaseServices.uid, widget.dish.id, true);
                      })
                    },
                    icon: const Icon(CupertinoIcons.heart, color: Colors.white),
                  );
                }
              },
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.dish.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price: \$${calculateTotalPrice().toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity = quantity > 1 ? quantity - 1 : 1;
                              });
                            },
                            icon: Icon(Icons.remove),
                          ),
                          Text('$quantity'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.dish.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Fournisseur:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  FutureBuilder<String?>(
                    future: fname,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error fetching fournisseur name');
                      } else {
                        String? fournisseurName = snapshot.data;
                        return Text(
                          fournisseurName ?? '',
                          style: TextStyle(fontSize: 16),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ingredients:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.dish.ingredients
                        .map((ingredient) => _buildIngredientItem(ingredient))
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Layers:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.dish.layers
                        .map((layer) => _buildLayerItem(layer))
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: addToCart,
                      child: Text("Add to Cart"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientItem(String ingredient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text(ingredient, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildLayerItem(Layer layer) {
    Option? selectedOption = selectedOptions[layer.layerName];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(layer.layerName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        DropdownButton<Option?>(
          value: selectedOption,
          onChanged: (newValue) {
            setState(() {
              selectedOptions[layer.layerName] = newValue;
            });
          },
          items: layer.options
              .map<DropdownMenuItem<Option?>>(
                  (option) => DropdownMenuItem<Option?>(
                        value: option,
                        child: Row(
                          children: [
                            Text(option.optionName),
                            SizedBox(width: 8),
                            Text('+' '\$${option.price.toStringAsFixed(2)}'),
                          ],
                        ),
                      ))
              .toList(),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  double calculateTotalPrice() {
    double totalPrice = widget.dish.price;
    selectedOptions.values.forEach((option) {
      if (option != null) {
        totalPrice += option.price;
      }
    });
    return totalPrice * quantity;
  }

  void addToCart() {
    List<Layer> selectedLayers = widget.dish.layers.map((layer) {
      return Layer(
        layerName: layer.layerName,
        options: [selectedOptions[layer.layerName] ?? layer.options.first],
      );
    }).toList();

    Dish selectedDish = widget.dish.copyWith(
        layers: selectedLayers,
        price: calculateTotalPrice(),
        quantity: quantity);

    cart.addItem(selectedDish.toCart());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

Future<bool> flipFutureBool(Future<bool> futureBool) async {
  bool originalValue = await futureBool;
  return !originalValue;
}
