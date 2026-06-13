

import 'package:meghana_exam6_june/domain/entities/user_entites.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.displayName,
    super.photoUrl,
    required super.createdAt,
  });

  factory UserModel.fromFirebase(dynamic u) => UserModel(
        uid: u.uid as String,
        email: (u.email as String?) ?? '',
        displayName: (u.displayName as String?) ?? 'User',
        photoUrl: u.photoURL as String?,
        createdAt: DateTime.now(),
      );

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
        uid: m['uid'] as String,
        email: m['email'] as String,
        displayName: m['displayName'] as String? ?? 'User',
        photoUrl: m['photoUrl'] as String?,
        createdAt: m['createdAt'] != null
            ? DateTime.parse(m['createdAt'] as String)
            : DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'createdAt': createdAt.toIso8601String(),
      };
}