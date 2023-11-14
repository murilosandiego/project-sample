import '../../domain/entities/account.dart';

class AccountModel {
  final String token;
  final String username;
  final int id;
  final String email;

  AccountModel({
    required this.token,
    required this.username,
    required this.id,
    required this.email,
  });

  factory AccountModel.fromJson(json) {
    return AccountModel(
        token: json["token"],
        username: json["username"],
        email: json["email"],
        id: int.parse(json["id"]));
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'email': email,
      'id': id,
    };
  }

  factory AccountModel.fromLocalStorage(json) => AccountModel(
        token: json["token"],
        username: json["username"],
        email: json["email"],
        id: json["id"],
      );

  Account toEntity() => Account(
        token: token,
        id: id,
        username: username,
        email: email,
      );
}
