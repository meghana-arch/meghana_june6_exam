class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromMap(String id, Map<String, dynamic> map) => UserModel(
    id: id,
    name: (map['name'] ?? '').toString(),
    email: (map['email'] ?? '').toString(),
  );
}