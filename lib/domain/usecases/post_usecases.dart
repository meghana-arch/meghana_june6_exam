import 'package:meghana_exam6_june/domain/entities/post_entities.dart';

import '../repositories/post_repository.dart';
import '../../core/utils/result.dart';

class GetPostsUseCase {
  final PostRepository _r;
  GetPostsUseCase(this._r);
  Future<Result<List<PostEntity>>> call({int limit = 20}) => _r.getPosts(limit: limit);
}

class GetPostUseCase {
  final PostRepository _r;
  GetPostUseCase(this._r);
  Future<Result<PostEntity>> call(int id) => _r.getPost(id);
}