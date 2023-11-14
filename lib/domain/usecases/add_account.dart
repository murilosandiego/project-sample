import 'package:equatable/equatable.dart';

import '../entities/account.dart';

abstract class AddAccount {
  Future<Account> add(AddAccountParams params);
}

class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String secret;

  AddAccountParams({
    required this.name,
    required this.email,
    required this.secret,
  });

  @override
  List get props => [email, secret, name];
}
