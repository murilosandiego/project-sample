import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/application/models/account_model.dart';
import 'package:news_app/application/storage/local_storage.dart';
import 'package:news_app/application/usecases/local_load_current_account.dart';
import 'package:news_app/domain/entities/account.dart';
import 'package:news_app/domain/errors/domain_error.dart';
import 'package:test/test.dart';

class LocalStorageSpy extends Mock implements CacheLocalStorage {}

void main() {
  late LocalStorageSpy localStorage;
  late LocalLoadCurrentAccount sut;
  late String token;
  late String username;
  late int id;
  late String email;

  mockSuccess(accountModel) {
    final accountEncoded = jsonEncode(accountModel.toJson());

    when(() => localStorage.fetch(key: any(named: 'key')))
        .thenAnswer((_) => accountEncoded);
  }

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalLoadCurrentAccount(localStorage: localStorage);
    token = faker.guid.guid();
    email = faker.internet.email();
    username = faker.person.name();
    id = faker.randomGenerator.integer(2);

    final accountModel =
        AccountModel(token: token, username: username, id: id, email: email);

    mockSuccess(accountModel);
  });

  test('Should call LocalStorage with currect value', () async {
    await sut.load();

    verify(() => localStorage.fetch(key: 'account'));
  });

  test('Should return an Account', () async {
    final account = await sut.load();

    expect(account,
        Account(token: token, username: username, id: id, email: email));
  });

  test('Should throw DomainError.unexpected if LocalStorage throws', () {
    when(() => localStorage.fetch(key: any(named: 'key')))
        .thenThrow(DomainError.unexpected);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
