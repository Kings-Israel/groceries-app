class User {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String location;
  final bool phoneVerified;

  User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.location,
    required this.phoneVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      location: json['location'],
      phoneVerified: json['phone_verified'] ?? false,
    );
  }
}
