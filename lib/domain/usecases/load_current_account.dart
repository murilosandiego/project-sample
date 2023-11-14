import 'dart:async';

import '../entities/account.dart';

abstract class LoadCurrentAccount {
  Future<Account?> load();
}
