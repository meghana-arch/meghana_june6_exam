

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meghana_exam6_june/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String name);
  Future<void> signOut();
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  AuthDataSourceImpl(this._auth, this._db);

  @override
  Future<UserModel> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
    return UserModel.fromFirebase(cred.user!);
  }

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
    await cred.user!.updateDisplayName(name.trim());
    final model = UserModel(
      uid: cred.user!.uid,
      email: email.trim(),
      displayName: name.trim(),
      photoUrl: null,
      createdAt: DateTime.now(),
    );
    await _db.collection('users').doc(model.uid).set(model.toMap());
    return model;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Stream<UserModel?> get authStateChanges =>
      _auth.authStateChanges().map((u) => u != null ? UserModel.fromFirebase(u) : null);

  @override
  UserModel? get currentUser {
    final u = _auth.currentUser;
    return u != null ? UserModel.fromFirebase(u) : null;
  }
}