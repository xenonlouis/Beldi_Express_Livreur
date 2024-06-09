import 'Layer.dart';

class Dish {
  late  String? id;
  late  String? idfournisseur;
  late  String name;
  late  String description;
  late  double price;
  late  List<String> ingredients;
  late  String imageUrl; // Added imageUrl field
  late  List<Layer> layers; // Changed layers to List<Layer>

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.ingredients,
    required this.imageUrl, // Initialize imageUrl
    required this.layers, // Initialize layers
    this.idfournisseur,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'layers': layers.map((layer) => layer.toMap()).toList(),
      'idfournisseur': idfournisseur,
    };
  }

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      ingredients: List<String>.from(json['ingredients']),
      imageUrl: json['imageUrl'],
      layers: (json['layers'] as List<dynamic>).map((layerJson) => Layer.fromJson(layerJson)).toList(),
        idfournisseur:json['idfournisseur'],
      // Convert each layer JSON to a Layer object
    );
  }

  Dish copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? ingredients,
    String? imageUrl,
    List<Layer>? layers,
    String? idfournisseur,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      ingredients: ingredients ?? this.ingredients,
      imageUrl: imageUrl ?? this.imageUrl,
      layers: layers ?? this.layers,
      idfournisseur: idfournisseur ?? this.idfournisseur,
    );
  }
}

