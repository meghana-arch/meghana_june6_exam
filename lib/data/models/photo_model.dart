

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meghana_exam6_june/domain/entities/photo_entities.dart';

class PhotoModel extends PhotoEntity {
  const PhotoModel({
    required super.id,
    required super.userId,
    required super.imageUrl,
    required super.watermarkedUrl,
    required super.latitude,
    required super.longitude,
    super.address,
    required super.createdAt,
  });

  factory PhotoModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return PhotoModel(
      id: doc.id,
      userId: d['userId'] as String? ?? '',
      imageUrl: d['imageUrl'] as String? ?? '',
      watermarkedUrl: d['watermarkedUrl'] as String? ?? '',
      latitude: (d['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (d['longitude'] as num?)?.toDouble() ?? 0.0,
      address: d['address'] as String?,
      createdAt: d['createdAt'] != null
          ? (d['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'imageUrl': imageUrl,
        'watermarkedUrl': watermarkedUrl,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}


