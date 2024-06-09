import 'package:client_app/services/FirebaseServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/Command.dart';
import '../Models/Layer.dart';
import '../Models/cart_model.dart';
import '../Models/dish.dart';
import '../Models/dishDTO.dart';
import 'dish_details.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "Your cart",
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
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          return cart.items.isEmpty
              ? const Center(child: Text('No items in your cart'))
              : ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DishDetailsPage(dish: Dish.fromJson(item)),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: item['imageUrl'] != null
                            ? Image.network(item['imageUrl'],
                                width: 50, height: 50)
                            : const Icon(Icons.fastfood),
                        title: Text(item["quantity"].toString() +
                                " " +
                                "x" +
                                " " +
                                item['name'] ??
                            'Unknown Item'),
                        subtitle: Text(
                            '\$${item['price']?.toStringAsFixed(2) ?? 'N/A'}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            cart.removeItem(item);
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<CartModel>(
            builder: (context, cart, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: ${cart.totalPrice.toStringAsFixed(2)} DH',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () {
                      if (cart.items.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter Delivery Details'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _addressController,
                                    decoration: const InputDecoration(
                                      labelText: 'Address',
                                    ),
                                  ),
                                  TextField(
                                    controller: _regionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Region',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final address = _addressController.text;
                                    final region = _regionController.text;
                                    createCommand(FirebaseServices.uid, cart,
                                        address, region);
                                    cart.clearCart();
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 17, color: Colors.green),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<void> createCommand(
    String userId, CartModel cart, String address, String region) async {
  final commandRef = FirebaseFirestore.instance.collection('Commandes').doc();
  final fournisseurDishes = <String, List<DishDTO>>{};
  final statusDishes = <String, String>{};

  // Group the dishes by fournisseur
  cart.items.forEach((item) {
    final fournisseurId = item['idfournisseur'].toString();
    final dishDTO = DishDTO(
      id: item['id'], // Add the dish ID
      name: item['name'],
      price: item['price'] ?? 0.0,
      layers: [], // Initialize layers; they'll be populated later
      quantity: item['quantity'] ?? 1,
    );
    fournisseurDishes.putIfAbsent(fournisseurId, () => []).add(dishDTO);
    statusDishes[dishDTO.id.toString()] = 'processing';
  });

  // Populate layers for each dish DTO
  fournisseurDishes.forEach((fournisseurId, dishes) {
    dishes.forEach((dishDTO) {
      final cartItem = cart.items.firstWhere(
        (item) => item['id'] == dishDTO.id,
      );
      if (cartItem != null) {
        dishDTO.layers = (cartItem['layers'] as List<dynamic>).map((layer) {
          final options = (layer['options'] as List<dynamic>).map((optionData) {
            return Option(
              optionName: optionData['optionName'] ?? 'Unknown Option',
              price: optionData['price'] ?? 0.0,
            );
          }).toList();
          return Layer(
            layerName: layer['layerName'],
            options: options,
          );
        }).toList();
      }
    });
  });

  // Create the Command object
  final command = Command(
    id: commandRef.id,
    address: address,
    totalprice: cart.totalPrice,
    clientId: userId,
    livreurId: '',
    region: region,
    status: 'processing',
    fournisseurDishes: fournisseurDishes,
    statusDishes: statusDishes,
    fournisseurIDs: fournisseurDishes.keys.toList(),
  );

  await commandRef.set(command.toJson());
}
