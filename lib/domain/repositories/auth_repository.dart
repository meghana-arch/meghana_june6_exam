
import 'package:meghana_exam6_june/domain/entities/user_entites.dart';

import '../../core/utils/result.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> signIn(String email, String password);
  Future<Result<UserEntity>> signUp(String email, String password, String name);
  Future<Result<void>> signOut();
  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;
}