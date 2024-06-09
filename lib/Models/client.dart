class Client {
  final String id;
  final String email;
  final String name;
  final String phone;
  final List<String> adresses;

  Client({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.adresses,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phoneNumber'] ?? '',
      adresses: List<String>.from(json['addresses'] ?? []),
    );
  }
}
