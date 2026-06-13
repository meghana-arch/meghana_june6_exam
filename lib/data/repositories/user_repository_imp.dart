import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final _col = FirebaseFirestore.instance.collection('users');

  Stream<List<UserModel>> getUsers() {
    return _col.snapshots().map((snap) =>
        snap.docs.map((d) => UserModel.fromMap(d.data())).toList());
  }
}