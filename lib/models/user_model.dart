class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.toString(),
    };
  }
}
