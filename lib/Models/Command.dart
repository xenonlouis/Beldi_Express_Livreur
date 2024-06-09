import 'dishDTO.dart';

class Command {
  String id;
  String address;
  double totalprice;
  String clientId;
  String livreurId;
  String region;
  String
      status; // Status can be 'Processing', 'Currently being made', 'Ready to be picked up', etc.
  Map<String, List<DishDTO>>
      fournisseurDishes; // Key: Fournisseur ID, Value: List of DishDTOs for that Fournisseur
  Map<String, String> statusDishes; // Key: Dish ID, Value: Status
  List<String> fournisseurIDs;

  Command({
    required this.id,
    required this.address,
    required this.totalprice,
    required this.clientId,
    required this.livreurId,
    required this.region,
    required this.status,
    required this.fournisseurDishes,
    required this.statusDishes,
    required this.fournisseurIDs,
  });

  factory Command.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> fournisseurDishesJson = json['fournisseurDishes'];
    Map<String, List<DishDTO>> fournisseurDishes = {};

    fournisseurDishesJson.forEach((key, value) {
      List<dynamic> dishesJson = value;
      List<DishDTO> dishes =
          dishesJson.map((dishJson) => DishDTO.fromJson(dishJson)).toList();
      fournisseurDishes[key] = dishes;
    });

    return Command(
      id: json['id'],
      address: json['address'],
      totalprice: json['totalprice'],
      clientId: json['clientId'],
      livreurId: json['livreurId'],
      region: json['region'],
      status: json['status'],
      fournisseurDishes: fournisseurDishes,
      statusDishes: Map<String, String>.from(json['statusDishes']),
      fournisseurIDs: List<String>.from(json['fournisseurIDs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'totalprice': totalprice,
      'clientId': clientId,
      'livreurId': livreurId,
      'region': region,
      'status': status,
      'fournisseurDishes': fournisseurDishes.map((key, value) =>
          MapEntry(key, value.map((dish) => dish.toJson()).toList())),
      'statusDishes': statusDishes,
      'fournisseurIDs': fournisseurIDs,
    };
  }
}
