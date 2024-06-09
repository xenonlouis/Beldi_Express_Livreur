class Fournisseur {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final List<String> dishIds; // List of dish IDs
  final String address;

  Fournisseur({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.dishIds,
    required this.address,
  });

  factory Fournisseur.fromJson(Map<String, dynamic> json) {
    return Fournisseur(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      dishIds: List<String>.from(json['dishIds'] ?? []),
      address: json['address'] ?? '',
    );
  }
}
