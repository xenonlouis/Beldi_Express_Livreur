import 'dishDTO.dart';

class Command {
  String id;
  String address;
  String clientId;
  String livreurId;
  String region;
  String status; // Status can be 'Processing', 'Currently being made', 'Ready to be picked up', etc.
  Map<String, List<DishDTO>> fournisseurDishes; // Key: Fournisseur ID, Value: List of DishDTOs for that Fournisseur
  Map<String, String> statusDishes; // Key: Dish ID, Value: Status
  List<String> fournisseurIDs;

  Command({
    required this.id,
    required this.address,
    required this.clientId,
    required this.livreurId,
    required this.region,
    required this.status,
    required this.fournisseurDishes,
    required this.statusDishes,
    required this.fournisseurIDs,
  });

  factory Command.fromJson(Map<String, dynamic> json) {
  return Command(
    id: json['id'],
    address: json['address'],
    clientId: json['clientId'],
    livreurId: json['livreurId'],
    region: json['region'],
    status: json['status'],
    fournisseurDishes: (json['fournisseurDishes'] as Map<String, dynamic>).map((key, value) {
      return MapEntry(key, (value as List<dynamic>).map((dishJson) {
        return DishDTO.fromJson(dishJson as Map<String, dynamic>);
      }).toList());
    }),
    statusDishes: Map<String, String>.from(json['statusDishes']),
    fournisseurIDs: List<String>.from(json['fournisseurIDs']),
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'clientId': clientId,
      'livreurId': livreurId,
      'region': region,
      'status': status,
      'fournisseurDishes': fournisseurDishes.map((key, value) => MapEntry(key, value.map((dish) => dish.toJson()).toList())),
      'statusDishes': statusDishes,
      'fournisseurIDs': fournisseurIDs,
    };
  }

  // Add a dish for a fournisseur
  void addDishForFournisseur(String fournisseurId, DishDTO dish) {
    if (fournisseurDishes.containsKey(fournisseurId)) {
      fournisseurDishes[fournisseurId]!.add(dish);
    } else {
      fournisseurDishes[fournisseurId] = [dish];
    }
  }

  // Remove a dish for a fournisseur
  void removeDishForFournisseur(String fournisseurId, DishDTO dish) {
    if (fournisseurDishes.containsKey(fournisseurId)) {
      fournisseurDishes[fournisseurId]!.remove(dish);
    }
  }

  // Update status for a dish
  void updateDishStatus(String dishId, String newStatus) {
    statusDishes[dishId] = newStatus;
  }
}
