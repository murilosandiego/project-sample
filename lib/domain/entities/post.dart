import 'package:equatable/equatable.dart';

import '../value_objects/message.dart';
import 'user.dart';

class PostEntity extends Equatable {
  PostEntity({
    required this.id,
    required this.user,
    required this.message,
  });

  final User user;
  final Message message;
  final int id;

  @override
  List get props => [user, message, id];

  PostEntity copyWith({
    User? user,
    Message? message,
    int? id,
  }) {
    return PostEntity(
      user: user ?? this.user,
      message: message ?? this.message,
      id: id ?? this.id,
    );
  }
}
