import 'dart:io';
import 'package:meghana_exam6_june/core/utils/watermark_utils.dart';
import 'package:meghana_exam6_june/domain/entities/photo_entities.dart';
import '../../domain/repositories/photo_repository.dart';
import '../../core/utils/result.dart';
import '../datasources/photo_datasource.dart';


class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoDataSource _ds;
  PhotoRepositoryImpl(this._ds);

  @override
Future<Result<PhotoEntity>> uploadPhoto({
  required File imageFile,
  required double latitude,
  required double longitude,
  required String userId,
  String? address,
  bool applyWatermark = true,
}) async {
  try {
    final File fileToUpload = applyWatermark
        ? await WatermarkUtil.applyWatermark(
            imageFile: imageFile,
            lat: latitude,
            lng: longitude,
            address: address, 
          )
        : imageFile;

    final photo = await _ds.upload(
      original: imageFile,
      watermarked: fileToUpload,
      lat: latitude,
      lng: longitude,
      userId: userId,
      address: address,
    );
    return Result.success(photo);
  } catch (e) {
    return Result.error(StorageFailure('Upload failed: $e'));
  }
}
  @override
  Future<Result<List<PhotoEntity>>> getUserPhotos(String userId) async {
    try {
      return Result.success(await _ds.getUserPhotos(userId));
    } catch (e) {
      return Result.error(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deletePhoto(String id, String url, String wmUrl) async {
    try {
      await _ds.delete(id, url, wmUrl);
      return const Result.success(null);
    } catch (e) {
      return Result.error(StorageFailure(e.toString()));
    }
  }
}