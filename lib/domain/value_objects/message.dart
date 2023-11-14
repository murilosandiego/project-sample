import 'package:equatable/equatable.dart';

class Message extends Equatable {
  Message({
    required this.content,
    required this.createdAt,
  });

  final String content;
  final DateTime createdAt;

  @override
  List get props => [content, createdAt];

  Message copyWith({
    String? content,
    DateTime? createdAt,
  }) {
    return Message(
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
