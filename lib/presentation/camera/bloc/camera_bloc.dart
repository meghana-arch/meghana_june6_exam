import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meghana_exam6_june/domain/entities/photo_entities.dart';
import 'package:meghana_exam6_june/domain/repositories/auth_repository.dart';
import 'package:meghana_exam6_june/domain/usecases/photo_usecases.dart';


abstract class CameraEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CameraUploadRequested extends CameraEvent {
  final File file;
  final ImageSource source;

  CameraUploadRequested(this.file, this.source);

  @override
  List<Object?> get props => [file.path, source];
}


abstract class CameraState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CameraIdle extends CameraState {}

class CameraUploading extends CameraState {}

class CameraUploadSuccess extends CameraState {
  final PhotoEntity photo;

  CameraUploadSuccess(this.photo);

  @override
  List<Object?> get props => [photo];
}

class CameraError extends CameraState {
  final String message;

  CameraError(this.message);

  @override
  List<Object?> get props => [message];
}


class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final UploadPhotoUseCase upload;
  final AuthRepository authRepo;

  CameraBloc({required this.upload, required this.authRepo})
      : super(CameraIdle()) {
    on<CameraUploadRequested>(_onUpload);
  }

  Future<String?> _getAddress(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;

      final p = placemarks.first;
      final parts = [
        p.street,
        p.subLocality,
        p.locality,
        p.administrativeArea,
        p.country,
      ].where((s) => s != null && s.isNotEmpty).toList();

      return parts.join(', ');
    } catch (_) {
      return null;
    }
  }

  Future<void> _onUpload(
    CameraUploadRequested e,
    Emitter<CameraState> emit,
  ) async {
    emit(CameraUploading());

    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        emit(CameraError('Location permission denied. Enable in settings.'));
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final address = await _getAddress(pos.latitude, pos.longitude);
      final uid = authRepo.currentUser?.uid ?? '';

      final result = await upload(
        imageFile: e.file,
        lat: pos.latitude,
        lng: pos.longitude,
        userId: uid,
        address: address,
        applyWatermark: e.source == ImageSource.gallery,
      );

      if (result.isSuccess) {
        emit(CameraUploadSuccess(result.data!));
      } else {
        emit(CameraError(result.failure!.message));
      }
    } catch (ex) {
      emit(CameraError('Error: $ex'));
    }
  }
}