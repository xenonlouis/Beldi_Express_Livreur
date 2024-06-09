
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Layer.dart';
import '../Models/dish.dart';

void addDishesToFirestore() {
  List<Dish> dishes = [
    Dish(
      id: '1',
      name: 'Pizza Margherita',
      description:
          'Classic Italian pizza with tomato sauce and mozzarella cheese.',
      price: 9.99,
      ingredients: ['Tomato Sauce', 'Mozzarella Cheese'],
      imageUrl: 'https://example.com/pizza_margherita.jpg',
      rating: 4.8,
      idfournisseur: "4yitjtd9sIPGsv1Q8gZD66GUM9A2",
      layers: [
        Layer(layerName: 'Crust', options: [
          Option(optionName: 'Thin Crust', price: 0.0),
          Option(optionName: 'Thick Crust', price: 1.0),
        ]),
        Layer(layerName: 'Toppings', options: [
          Option(optionName: 'Pepperoni', price: 1.0),
          Option(optionName: 'Mushrooms', price: 0.5),
          Option(optionName: 'Olives', price: 0.5),
        ]),
      ],
    ),
    Dish(
      id: '2',
      name: 'Chicken Tikka Masala',
      description:
          'Indian dish with grilled chicken in a creamy tomato-based sauce.',
          idfournisseur: "4yitjtd9sIPGsv1Q8gZD66GUM9A2",
      price: 12.99,
      ingredients: ['Chicken', 'Tomato Sauce', 'Spices'],
      imageUrl: 'https://example.com/chicken_tikka_masala.jpg',
      rating: 4.7,
      layers: [
        Layer(layerName: 'Spiciness', options: [
          Option(optionName: 'Mild', price: 0.0),
          Option(optionName: 'Medium', price: 0.0),
          Option(optionName: 'Spicy', price: 0.0),
        ]),
        Layer(layerName: 'Side Dish', options: [
          Option(optionName: 'Rice', price: 2.0),
          Option(optionName: 'Naan', price: 1.5),
          Option(optionName: 'Roti', price: 1.5),
        ]),
      ],
    ),
    Dish(
      id: '3',
      name: 'Sushi Roll',
      description:
          'Japanese dish with vinegared rice, seafood, and vegetables wrapped in seaweed.',
      price: 15.99,
      idfournisseur: "4yitjtd9sIPGsv1Q8gZD66GUM9A2",
      ingredients: ['Rice', 'Seafood', 'Vegetables', 'Seaweed'],
      imageUrl: 'https://example.com/sushi_roll.jpg',
      rating: 4.9,
      layers: [
        Layer(layerName: 'Type', options: [
          Option(optionName: 'California Roll', price: 0.0),
          Option(optionName: 'Spicy Tuna Roll', price: 0.0),
          Option(optionName: 'Rainbow Roll', price: 0.0),
        ]),
        Layer(layerName: 'Extra', options: [
          Option(optionName: 'Avocado', price: 1.0),
          Option(optionName: 'Cream Cheese', price: 1.0),
          Option(optionName: 'Tempura', price: 2.0),
        ]),
      ],
    ),
    Dish(
      id: '4',
      name: 'Caesar Salad',
      description:
          'Fresh salad with romaine lettuce, croutons, parmesan cheese, and Caesar dressing.',
      price: 8.99,
      idfournisseur: "4yitjtd9sIPGsv1Q8gZD66GUM9A2",
      ingredients: [
        'Romaine Lettuce',
        'Croutons',
        'Parmesan Cheese',
        'Caesar Dressing'
      ],
      imageUrl: 'https://example.com/caesar_salad.jpg',
      rating: 4.5,
      layers: [
        Layer(layerName: 'Add-ons', options: [
          Option(optionName: 'Grilled Chicken', price: 2.0),
          Option(optionName: 'Shrimp', price: 3.0),
          Option(optionName: 'Salmon', price: 4.0),
        ]),
      ],
    ),
    Dish(
      id: '5',
      name: 'Beef Burger',
      description:
          'Classic American burger with beef patty, lettuce, tomato, onion, and cheese.',
          idfournisseur: "4yitjtd9sIPGsv1Q8gZD66GUM9A2",
      price: 11.99,
      ingredients: ['Beef Patty', 'Lettuce', 'Tomato', 'Onion', 'Cheese'],
      imageUrl: 'https://example.com/beef_burger.jpg',
      rating: 4.6,
      layers: [
        Layer(layerName: 'Cheese', options: [
          Option(optionName: 'Cheddar', price: 0.0),
          Option(optionName: 'Swiss', price: 0.0),
          Option(optionName: 'Blue Cheese', price: 0.5),
        ]),
        Layer(layerName: 'Toppings', options: [
          Option(optionName: 'Bacon', price: 1.0),
          Option(optionName: 'Mushrooms', price: 0.5),
          Option(optionName: 'Jalapenos', price: 0.5),
        ]),
      ],
    ),
  ];

  // Add each dish to Firestore
  dishes.forEach((dish) {
    Map<String, dynamic> dishData = dish.toMap();
    FirebaseFirestore.instance
        .collection('Dishes')
        .doc(dish.id)
        .set(dishData)
        .then((_) {
      print('Dish ${dish.name} added to Firestore successfully!');
    }).catchError((error) {
      print('Error adding dish ${dish.name} to Firestore: $error');
    });
  });
}
