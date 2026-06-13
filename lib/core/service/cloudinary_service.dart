import 'dart:io';
import 'package:dio/dio.dart';

class CloudinaryService {
  static const String _cloudName = 'dsg5upeuw';
  static const String _uploadPreset = 'flutter_upload';

  static Future<String> uploadImage(File imageFile) async {
    try {
      final dio = Dio();

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'upload_preset': _uploadPreset,
        'folder': 'photos',
      });

      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['secure_url'] as String;
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Cloudinary upload error: $e');
    }
  }
}
