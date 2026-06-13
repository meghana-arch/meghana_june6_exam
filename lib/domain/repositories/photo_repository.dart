import 'dart:io';
import 'package:meghana_exam6_june/domain/entities/photo_entities.dart';

import '../../core/utils/result.dart';

abstract class PhotoRepository {
  Future<Result<PhotoEntity>> uploadPhoto({
    required File imageFile,
    required double latitude,
    required double longitude,
    required String userId,
    String? address,
      bool applyWatermark = true,
  });
  Future<Result<List<PhotoEntity>>> getUserPhotos(String userId);
  Future<Result<void>> deletePhoto(String photoId, String imageUrl, String watermarkedUrl);
}