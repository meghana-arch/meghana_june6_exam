import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meghana_exam6_june/domain/entities/user_entites.dart';
import '../../../domain/usecases/auth_usecases.dart';

abstract class AuthEvent extends Equatable {
  @override List<Object?> get props => [];
}
class AuthStarted extends AuthEvent {}
class AuthSignInRequested extends AuthEvent {
  final String email, password;
  AuthSignInRequested(this.email, this.password);
  @override List<Object?> get props => [email, password];
}
class AuthSignUpRequested extends AuthEvent {
  final String email, password, name;
  AuthSignUpRequested(this.email, this.password, this.name);
  @override List<Object?> get props => [email, password, name];
}
class AuthSignOutRequested extends AuthEvent {}
class _AuthUserChanged extends AuthEvent {
  final UserEntity? user;
  _AuthUserChanged(this.user);
  @override List<Object?> get props => [user];
}

abstract class AuthState extends Equatable {
  @override List<Object?> get props => [];
}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  AuthAuthenticated(this.user);
  @override List<Object?> get props => [user];
}
class AuthUnauthenticated extends AuthState {}
class AuthFailureState extends AuthState {
  final String message;
  AuthFailureState(this.message);
  @override List<Object?> get props => [message];
}
class AuthSignUpSuccess extends AuthState {}


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signIn;
  final SignUpUseCase signUp;
  final SignOutUseCase signOut;
  final WatchAuthUseCase watchAuth;
  StreamSubscription? _sub;
  
  bool _isSigningUp = false;

  AuthBloc({required this.signIn, required this.signUp,
            required this.signOut, required this.watchAuth})
      : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthSignOutRequested>(_onSignOut);
    on<_AuthUserChanged>(_onUserChanged);
  }

  void _onStarted(AuthStarted e, Emitter<AuthState> emit) {
    _sub?.cancel();
    _sub = watchAuth().listen((u) => add(_AuthUserChanged(u)));
  }

  void _onUserChanged(_AuthUserChanged e, Emitter<AuthState> emit) {
    if (_isSigningUp) return;

    if (e.user != null) {
      emit(AuthAuthenticated(e.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignIn(AuthSignInRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final r = await signIn(e.email, e.password);
    if (r.isSuccess) {
      emit(AuthAuthenticated(r.data!));
    } else {
      emit(AuthFailureState(r.failure!.message));
    }
  }

  Future<void> _onSignUp(AuthSignUpRequested e, Emitter<AuthState> emit) async {
    _isSigningUp = true; 
    emit(AuthLoading());
    try {
      final r = await signUp(e.email, e.password, e.name);
      if (r.isSuccess) {
        await signOut(); 
        emit(AuthSignUpSuccess()); 
      } else {
        emit(AuthFailureState(r.failure!.message));
      }
    } finally {
      _isSigningUp = false; 
    }
  }

  Future<void> _onSignOut(AuthSignOutRequested e, Emitter<AuthState> emit) async {
    await signOut();
    emit(AuthUnauthenticated());
  }

  @override
  Future<void> close() { _sub?.cancel(); return super.close(); }
}