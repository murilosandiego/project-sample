import 'package:news_app/domain/entities/user.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    this.profilePicture,
  });

  final int id;
  final String name;
  final String? profilePicture;

  User toEntity() => User(id: id, name: name, email: '');
}
