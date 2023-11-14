import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/application/models/account_model.dart';
import 'package:news_app/application/storage/local_storage.dart';
import 'package:news_app/application/usecases/local_save_current_account.dart';
import 'package:news_app/domain/entities/account.dart';
import 'package:news_app/domain/errors/domain_error.dart';
import 'package:test/test.dart';

class LocalStorageSpy extends Mock implements CacheLocalStorage {}

void main() {
  late LocalStorageSpy localStorage;
  late LocalSaveCurrentAccount sut;
  late Account account;

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalSaveCurrentAccount(localStorage: localStorage);
    account = Account(
        token: faker.guid.guid(),
        id: faker.randomGenerator.integer(3),
        username: faker.person.name(),
        email: faker.internet.email());
  });

  test('Should call the save method of LocalStorage with correct values',
      () async {
    when(() => localStorage.save(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) => Future.value());

    final accountModel = AccountModel(
        token: account.token,
        username: account.username,
        id: account.id,
        email: account.email);

    await sut.save(account);

    verify(
      () => localStorage.save(
        key: 'account',
        value: jsonEncode(accountModel.toJson()),
      ),
    );
  });

  test('Should throw UnexpectedError if LocalStorage throws', () {
    when(() => localStorage.save(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenThrow(Exception());

    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
