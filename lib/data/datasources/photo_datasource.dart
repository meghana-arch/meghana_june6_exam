import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meghana_exam6_june/core/service/cloudinary_service.dart';
import '../models/photo_model.dart';

abstract class PhotoDataSource {
  Future<PhotoModel> upload({
    required File original,
    required File watermarked,
    required double lat,
    required double lng,
    required String userId,
    String? address,
  });
  Future<List<PhotoModel>> getUserPhotos(String userId);
  Future<void> delete(String photoId, String imageUrl, String watermarkedUrl);
}

class PhotoDataSourceImpl implements PhotoDataSource {
  final FirebaseFirestore _db;

  PhotoDataSourceImpl(this._db);

  @override
  Future<PhotoModel> upload({
    required File original,
    required File watermarked,
    required double lat,
    required double lng,
    required String userId,
    String? address,
  }) async {
    final imageUrl = await CloudinaryService.uploadImage(original);
    final wmUrl = await CloudinaryService.uploadImage(watermarked);

    final model = PhotoModel(
      id: '',
      userId: userId,
      imageUrl: imageUrl,
      watermarkedUrl: wmUrl,
      latitude: lat,
      longitude: lng,
      address: address,
      createdAt: DateTime.now(),
    );

    final ref = await _db.collection('photos').add(model.toMap());
    return PhotoModel(
      id: ref.id,
      userId: userId,
      imageUrl: imageUrl,
      watermarkedUrl: wmUrl,
      latitude: lat,
      longitude: lng,
      address: address,
      createdAt: model.createdAt,
    );
  }

  @override
  Future<List<PhotoModel>> getUserPhotos(String userId) async {
    final snap = await _db
        .collection('photos')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => PhotoModel.fromFirestore(d)).toList();
  }

  @override
  Future<void> delete(String photoId, String imageUrl, String wmUrl) async {
    await _db.collection('photos').doc(photoId).delete();
  }
}