import 'package:equatable/equatable.dart';

class User extends Equatable {
  User({
    required this.id,
    required this.name,
    this.email = '',
    this.profilePicture,
  });

  final int id;
  final String name;
  final String? profilePicture;
  final String email;

  @override
  List<Object?> get props => [id, name, profilePicture, email];
}
