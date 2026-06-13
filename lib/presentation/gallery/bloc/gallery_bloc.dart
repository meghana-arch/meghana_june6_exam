import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meghana_exam6_june/domain/entities/photo_entities.dart';
import 'package:meghana_exam6_june/domain/repositories/auth_repository.dart';
import 'package:meghana_exam6_june/domain/usecases/photo_usecases.dart';

abstract class GalleryEvent extends Equatable {
  @override List<Object?> get props => [];
}
class GalleryLoadRequested extends GalleryEvent {}
class GalleryDeleteRequested extends GalleryEvent {
  final PhotoEntity photo;
  GalleryDeleteRequested(this.photo);
  @override List<Object?> get props => [photo.id];
}

abstract class GalleryState extends Equatable {
  @override List<Object?> get props => [];
}
class GalleryInitial extends GalleryState {}
class GalleryLoading extends GalleryState {}
class GalleryLoaded extends GalleryState {
  final List<PhotoEntity> photos;
  GalleryLoaded(this.photos);
  @override List<Object?> get props => [photos];
}
class GalleryError extends GalleryState {
  final String message;
  GalleryError(this.message);
  @override List<Object?> get props => [message];
}

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetUserPhotosUseCase getPhotos;
  final DeletePhotoUseCase deletePhoto;
  final AuthRepository authRepo;

  GalleryBloc({required this.getPhotos, required this.deletePhoto, required this.authRepo})
      : super(GalleryInitial()) {
    on<GalleryLoadRequested>(_onLoad);
    on<GalleryDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(GalleryLoadRequested e, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    final uid = authRepo.currentUser?.uid ?? '';
    final result = await getPhotos(uid);
    if (result.isSuccess) {
      emit(GalleryLoaded(result.data!));
    } else {
      emit(GalleryError(result.failure!.message));
    }
  }

  Future<void> _onDelete(GalleryDeleteRequested e, Emitter<GalleryState> emit) async {
    final current = state;
    if (current is GalleryLoaded) {
      final updated = current.photos.where((p) => p.id != e.photo.id).toList();
      emit(GalleryLoaded(updated));
      await deletePhoto(e.photo.id, e.photo.imageUrl, e.photo.watermarkedUrl);
    }
  }
}