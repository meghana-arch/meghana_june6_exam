import 'package:equatable/equatable.dart';

class PhotoEntity extends Equatable {
  final String id;
  final String userId;
  final String imageUrl;
  final String watermarkedUrl;
  final double latitude;
  final double longitude;
  final String? address;
  final DateTime createdAt;
  final String? locationName; 

  const PhotoEntity({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.watermarkedUrl,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.createdAt, this.locationName,
  });

  @override
  List<Object?> get props =>
      [id, userId, imageUrl, watermarkedUrl, latitude, longitude, createdAt];
}