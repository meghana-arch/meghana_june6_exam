import 'dart:io';
import 'package:meghana_exam6_june/domain/entities/photo_entities.dart';
import '../repositories/photo_repository.dart';
import '../../core/utils/result.dart';

class UploadPhotoUseCase {
  final PhotoRepository _r;
  UploadPhotoUseCase(this._r);
  Future<Result<PhotoEntity>> call({
    required File imageFile,
    required double lat,
    required double lng,
    required String userId,
     String? address, 
     bool applyWatermark = true,
  }) => _r.uploadPhoto(imageFile: imageFile, latitude: lat, longitude: lng, userId: userId,address: address, applyWatermark: applyWatermark);
}

class GetUserPhotosUseCase {
  final PhotoRepository _r;
  GetUserPhotosUseCase(this._r);
  Future<Result<List<PhotoEntity>>> call(String userId) => _r.getUserPhotos(userId);
}

class DeletePhotoUseCase {
  final PhotoRepository _r;
  DeletePhotoUseCase(this._r);
  Future<Result<void>> call(String id, String url, String wmUrl) =>
      _r.deletePhoto(id, url, wmUrl);
}