import 'package:shared_preferences/shared_preferences.dart';

import '../../application/storage/local_storage.dart';

class LocalStorageAdapter implements CacheLocalStorage {
  final SharedPreferences localStorage;

  LocalStorageAdapter({required this.localStorage});

  @override
  Future<void> save({required key, required value}) async {
    await localStorage.setString(key, value);
  }

  @override
  String? fetch({required String key}) {
    return localStorage.getString(key);
  }

  @override
  Future<void> clear() async {
    await localStorage.clear();
  }
}
