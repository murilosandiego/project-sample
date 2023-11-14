import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String token;
  final String username;
  final String email;
  final int id;

  Account({
    required this.token,
    required this.id,
    required this.username,
    required this.email,
  });

  @override
  List get props => [token, id, username, email];
}
