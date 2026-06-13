import 'package:meghana_exam6_june/domain/entities/user_entites.dart';

import '../repositories/auth_repository.dart';
import '../../core/utils/result.dart';

class SignInUseCase {
  final AuthRepository _r;
  SignInUseCase(this._r);
  Future<Result<UserEntity>> call(String email, String pass) => _r.signIn(email, pass);
}

class SignUpUseCase {
  final AuthRepository _r;
  SignUpUseCase(this._r);
  Future<Result<UserEntity>> call(String email, String pass, String name) =>
      _r.signUp(email, pass, name);
}

class SignOutUseCase {
  final AuthRepository _r;
  SignOutUseCase(this._r);
  Future<Result<void>> call() => _r.signOut();
}

class WatchAuthUseCase {
  final AuthRepository _r;
  WatchAuthUseCase(this._r);
  Stream<UserEntity?> call() => _r.authStateChanges;
}