import 'dart:convert';

import '../../domain/entities/account.dart';
import '../../domain/errors/domain_error.dart';
import '../../domain/usecases/save_current_account.dart';
import '../models/account_model.dart';
import '../storage/local_storage.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final CacheLocalStorage localStorage;

  LocalSaveCurrentAccount({required this.localStorage});

  @override
  Future<void> save(Account account) async {
    try {
      final accountModel = AccountModel(
          token: account.token,
          username: account.username,
          id: account.id,
          email: account.email);

      await localStorage.save(key: 'account', value: jsonEncode(accountModel));
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
