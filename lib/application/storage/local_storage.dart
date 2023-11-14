abstract class CacheLocalStorage {
  Future<void> save({required String key, required String value});
  String? fetch({required String key});
  Future<void> clear();
}
