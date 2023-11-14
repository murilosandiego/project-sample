import 'dart:async';
import 'dart:convert';

import '../../domain/entities/account.dart';
import '../../domain/errors/domain_error.dart';
import '../../domain/usecases/load_current_account.dart';
import '../models/account_model.dart';
import '../storage/local_storage.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final CacheLocalStorage localStorage;

  LocalLoadCurrentAccount({required this.localStorage});

  @override
  Future<Account?> load() async {
    try {
      final resultFetched = localStorage.fetch(key: 'account');

      return resultFetched == null
          ? null
          : AccountModel.fromLocalStorage(jsonDecode(resultFetched)).toEntity();
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
