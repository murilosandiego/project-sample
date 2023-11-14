import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/infra/storage/local_storage_adater.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStorageAdapter sut;
  late String key;
  late String value;
  late SharedPreferences localStorage;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'fetch_key': 'fetch_value'});

    localStorage = await SharedPreferences.getInstance();
  });

  setUp(() async {
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  tearDownAll(() {
    localStorage.clear();
  });

  group('Save method', () {
    test('Should call LocalStorage with correct values', () async {
      key = faker.randomGenerator.string(4);
      value = faker.randomGenerator.string(10);

      await sut.save(key: key, value: value);

      expect(localStorage.getString(key), value);
    });
  });

  group('Fetch method', () {
    test('Should return a value with success', () async {
      final valueResult = sut.fetch(key: 'fetch_key');

      expect(valueResult, 'fetch_value');
    });
  });

  group('Clear method', () {
    test('Should call LocalStorage with correct values', () async {
      await sut.clear();

      expect(localStorage.getString('fetch_key'), null);
    });
  });
}
