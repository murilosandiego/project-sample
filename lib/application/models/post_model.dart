import 'package:news_app/domain/entities/post.dart';

import 'message_model.dart';
import 'user_model.dart';

class PostModel {
  PostModel({
    required this.user,
    required this.message,
    required this.id,
  });

  final UserModel user;
  final MessageModel message;
  final int id;

  factory PostModel.fromJsonApiPosts(Map<String, dynamic> json) => PostModel(
        id: int.parse(json["id"]),
        user: UserModel(
          name: json["username"],
          id: json["userId"],
        ),
        message: MessageModel(
            content: json["content"],
            createdAt: DateTime.parse(json["createdAt"])),
      );

  PostEntity toEntity() => PostEntity(
        id: id,
        user: user.toEntity(),
        message: message.toEntity(),
      );
}
