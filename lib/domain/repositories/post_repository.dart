import 'package:meghana_exam6_june/domain/entities/post_entities.dart';
import '../../core/utils/result.dart';

abstract class PostRepository {
  Future<Result<List<PostEntity>>> getPosts({int limit = 20});
  Future<Result<PostEntity>> getPost(int id);
}