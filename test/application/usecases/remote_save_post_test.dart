import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/application/http/http_client.dart';
import 'package:news_app/application/http/http_error.dart';
import 'package:news_app/application/usecases/remote_save_post.dart';
import 'package:news_app/domain/entities/post.dart';
import 'package:news_app/domain/errors/domain_error.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  late RemoteSavePost sut;
  late HttpClientMock httpClient;
  late String path;
  late String message;
  // Map body;

  mockSuccess() => when(
        () => httpClient.request(
          path: any(named: 'path'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => jsonDecode(factoryNewPostApiResponse),
      );

  mockError(HttpError error) => when(
        () => httpClient.request(
          path: any(named: 'path'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      ).thenThrow(error);

  setUpAll(() {
    registerFallbackValue(HttpMethod.post);
    registerFallbackValue(HttpMethod.put);
  });

  setUp(() {
    httpClient = HttpClientMock();
    path = faker.internet.httpUrl();

    sut = RemoteSavePost(
      httpClient: httpClient,
      path: path,
    );

    message = faker.randomGenerator.string(280);

    mockSuccess();
  });

  group('Create Post', () {
    test('should return an PostEntity if HttpClient returns 200', () async {
      final post = await sut.save(message: message);

      expect(post, isA<PostEntity>());
      expect(post.user.name, equals('username 1'));
      expect(post.message.content, equals('content 1'));
    });

    test('should throw UnexpectedError if HttpClient not return 200', () {
      mockError(HttpError.badRequest);

      final future = sut.save(message: message);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
