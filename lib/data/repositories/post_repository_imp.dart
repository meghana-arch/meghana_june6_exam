import 'package:meghana_exam6_june/domain/entities/post_entities.dart';

import '../../domain/repositories/post_repository.dart';
import '../../core/utils/result.dart';
import '../datasources/post_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource _ds;
  PostRepositoryImpl(this._ds);

  @override
  Future<Result<List<PostEntity>>> getPosts({int limit = 20}) async {
    try {
      return Result.success(await _ds.getPosts(limit: limit));
    } catch (e) {
      return Result.error(NetworkFailure('Failed to load posts: $e'));
    }
  } 

  @override
  Future<Result<PostEntity>> getPost(int id) async {
    try {
      return Result.success(await _ds.getPost(id));
    } catch (e) {
      return Result.error(NetworkFailure(e.toString()));
    }
  }
}