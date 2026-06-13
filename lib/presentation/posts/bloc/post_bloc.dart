import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meghana_exam6_june/domain/entities/post_entities.dart';
import 'package:meghana_exam6_june/domain/usecases/post_usecases.dart';

abstract class PostEvent extends Equatable {
  @override List<Object?> get props => [];
}
class PostLoadRequested extends PostEvent {}
class PostSearchChanged extends PostEvent {
  final String query;
  PostSearchChanged(this.query);
  @override List<Object?> get props => [query];
}
class PostRefreshRequested extends PostEvent {}

abstract class PostState extends Equatable {
  @override List<Object?> get props => [];
}
class PostInitial extends PostState {}
class PostLoading extends PostState {}
class PostLoaded extends PostState {
  final List<PostEntity> all;
  final List<PostEntity> filtered;
  final String query;
  PostLoaded({required this.all, required this.filtered, this.query = ''});
  PostLoaded copyWith({List<PostEntity>? all, List<PostEntity>? filtered, String? query}) =>
      PostLoaded(
        all: all ?? this.all,
        filtered: filtered ?? this.filtered,
        query: query ?? this.query,
      );
  @override List<Object?> get props => [all, filtered, query];
}
class PostError extends PostState {
  final String message;
  PostError(this.message);
  @override List<Object?> get props => [message];
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase getPosts;
  PostBloc({required this.getPosts}) : super(PostInitial()) {
    on<PostLoadRequested>(_onLoad);
    on<PostRefreshRequested>(_onLoad);
    // on<PostSearchChanged>(_onSearch);
  }

  Future<void> _onLoad(PostEvent e, Emitter<PostState> emit) async {
    emit(PostLoading());
    final r = await getPosts(limit: 30);
    if (r.isSuccess) {
      final posts = r.data!;
      emit(PostLoaded(all: posts, filtered: posts));
    } else {
      emit(PostError(r.failure!.message));
    }
  }

  // void _onSearch(PostSearchChanged e, Emitter<PostState> emit) {
  //   if (state is PostLoaded) {
  //     final s = state as PostLoaded;
  //     final q = e.query.toLowerCase().trim();
  //     final filtered = q.isEmpty
  //         ? s.all
  //         : s.all.where((p) =>
  //             p.title.toLowerCase().contains(q) ||
  //             p.body.toLowerCase().contains(q)).toList();
  //     emit(s.copyWith(filtered: filtered, query: q));
  //   }
  // }
}