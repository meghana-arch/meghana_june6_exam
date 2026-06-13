

import 'package:meghana_exam6_june/domain/entities/post_entities.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> j) => PostModel(
        id: j['id'] as int,
        userId: j['userId'] as int,
        title: j['title'] as String,
        body: j['body'] as String,
      );
}