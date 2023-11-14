import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/application/http/http_client.dart';
import 'package:news_app/application/http/http_error.dart';
import 'package:news_app/application/usecases/remote_add_account.dart';
import 'package:news_app/domain/errors/domain_error.dart';
import 'package:news_app/domain/usecases/add_account.dart';
import 'package:test/test.dart';

import '../../mocks/mocks.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  late RemoteAddAccount sut;
  late HttpClientMock httpClient;
  late String path;
  late AddAccountParams params;

  mockSuccess() => when(
        () => httpClient.request(
          path: any(named: 'path'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => jsonDecode(factoryApiResponse),
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
  });

  setUp(() {
    httpClient = HttpClientMock();
    path = faker.internet.httpUrl();

    sut = RemoteAddAccount(
      httpClient: httpClient,
      path: path,
    );
    params = AddAccountParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
      name: faker.person.name(),
    );

    mockSuccess();
  });

  test('should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(
      () => httpClient.request(
        path: path,
        method: HttpMethod.post,
        body: {
          'username': params.name,
          'email': params.email,
          'password': params.secret
        },
      ),
    );
  });

  test('should throw UnexpectedError if HttpClient returns 400', () {
    mockError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () {
    mockError(HttpError.notFound);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () {
    mockError(HttpError.serverError);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw InvalidCredentialsError if HttpClient returns 401', () {
    mockError(HttpError.unauthorized);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('should return an Account if HttpClient returns 200', () async {
    final account = await sut.add(params);

    expect(account.token, 'token 1');
    expect(account.username, 'username 1');
    expect(account.id, 1);
  });
}
