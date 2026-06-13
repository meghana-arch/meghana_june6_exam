import 'package:dio/dio.dart';
import '../models/post_model.dart';

abstract class PostDataSource {
  Future<List<PostModel>> getPosts({int limit = 20});
  Future<PostModel> getPost(int id);
}

class PostDataSourceImpl implements PostDataSource {
  final Dio _dio;
  PostDataSourceImpl(this._dio);

  @override
  Future<List<PostModel>> getPosts({int limit = 20}) async {
    final res = await _dio.get(
      'https://jsonplaceholder.typicode.com/posts',
      queryParameters: {'_limit': limit},
    );
    return (res.data as List).map((j) => PostModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  @override
  Future<PostModel> getPost(int id) async {
    final res = await _dio.get('https://jsonplaceholder.typicode.com/posts/$id');
    return PostModel.fromJson(res.data as Map<String, dynamic>);
  }
}