import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/application/http/http_client.dart';
import 'package:news_app/application/http/http_error.dart';
import 'package:news_app/application/usecases/remote_load_posts.dart';
import 'package:news_app/domain/entities/post.dart';
import 'package:news_app/domain/errors/domain_error.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  late RemoteLoadPosts sut;
  late HttpClientMock httpClient;
  late String path;

  mockSuccess() => when(
        () => httpClient.request(
          path: any(named: 'path'),
          method: any(named: 'method'),
        ),
      ).thenAnswer((_) async => jsonDecode(apiResponsePosts));

  mockError() => when(
        () => httpClient.request(
          path: any(named: 'path'),
          method: any(named: 'method'),
        ),
      ).thenThrow(HttpError.serverError);

  setUpAll(() {
    registerFallbackValue(HttpMethod.get);
  });

  setUp(() {
    httpClient = HttpClientMock();
    path = faker.internet.httpUrl();

    sut = RemoteLoadPosts(
      httpClient: httpClient,
      path: path,
    );

    mockSuccess();
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(
      () => httpClient.request(
        path: path,
        method: HttpMethod.get,
      ),
    );
  });

  test('Should return news on 200', () async {
    final news = await sut.load();

    expect(news, isA<List<PostEntity>>());
    expect(news[1].user.name, equals('username 1'));
    expect(news[1].message.content, equals('content 1'));
    expect(news[1].id, equals(1));
    expect(news[1].message.createdAt, DateTime(2028, 10, 26));

    expect(news[0].user.name, equals('username 2'));
    expect(news[0].message.content, equals('content 2'));
    expect(news[0].id, equals(2));
    expect(news[0].message.createdAt, DateTime(2048, 10, 30));
  });

  test('Should throw UnexpectedError if HttpClient not returns 200', () {
    mockError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
