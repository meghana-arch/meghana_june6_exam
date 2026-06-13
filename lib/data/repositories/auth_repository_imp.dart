import 'package:firebase_auth/firebase_auth.dart';
import 'package:meghana_exam6_june/domain/entities/user_entites.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/utils/result.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _ds;
  AuthRepositoryImpl(this._ds);

  @override
  Future<Result<UserEntity>> signIn(String email, String pass) async {
    try {
      return Result.success(await _ds.signIn(email, pass));
    } on FirebaseAuthException catch (e) {
      return Result.error(AuthFailure(_authMsg(e.code)));
    } catch (e) {
      return Result.error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> signUp(String email, String pass, String name) async {
    try {
      return Result.success(await _ds.signUp(email, pass, name));
    } on FirebaseAuthException catch (e) {
      return Result.error(AuthFailure(_authMsg(e.code)));
    } catch (e) {
      return Result.error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _ds.signOut();
      return const Result.success(null);
    } catch (e) {
      return Result.error(AuthFailure(e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges => _ds.authStateChanges;

  @override
  UserEntity? get currentUser => _ds.currentUser;

  String _authMsg(String code) {
    switch (code) {
      case 'user-not-found': return 'No account found with this email.';
      case 'wrong-password': return 'Incorrect password. Try again.';
      case 'email-already-in-use': return 'Email already registered.';
      case 'invalid-email': return 'Invalid email address.';
      case 'weak-password': return 'Password must be at least 6 characters.';
      case 'too-many-requests': return 'Too many attempts. Try again later.';
      case 'network-request-failed': return 'Check your internet connection.';
      default: return 'Authentication failed. Try again.';
    }
  }
}