import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meghana_exam6_june/data/repositories/user_repository_imp.dart';
import 'package:meghana_exam6_june/presentation/users/bloc/user_event.dart';
import 'package:meghana_exam6_june/presentation/users/bloc/user_state.dart';
import '../../../data/models/user_model.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserRepository _repo;

  UsersBloc(this._repo) : super(UsersInitial()) {
    on<LoadUsers>((event, emit) async {
  emit(UsersLoading());
  await emit.forEach<List<UserModel>>(
    _repo.getUsers(),
    onData: (users) => UsersLoaded(users),
    onError: (e, stack) {
      print('🔴 UsersBloc Error: $e');       
      print('🔴 StackTrace: $stack');        
      return UsersError(e.toString());
    },
  );
});
  }
}