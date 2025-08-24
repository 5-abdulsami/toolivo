class CustomerModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final DateTime createdAt;

  CustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      phone: map['phone'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
