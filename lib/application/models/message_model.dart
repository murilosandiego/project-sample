import 'package:news_app/domain/value_objects/message.dart';

class MessageModel {
  MessageModel({
    required this.content,
    required this.createdAt,
  });

  final String content;
  final DateTime createdAt;

  Message toEntity() => Message(
        content: content,
        createdAt: createdAt,
      );
}
