import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/application/http/http_client.dart';
import 'package:news_app/application/http/http_error.dart';
import 'package:news_app/infra/http/http_adapter.dart';
import 'package:test/test.dart';

class ClientMock extends Mock implements Client {}

class FakeUri extends Fake implements Uri {}

main() {
  late HttpAdapter sut;
  late ClientMock client;
  late String path;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    client = ClientMock();
    sut = HttpAdapter(client);
    path = faker.internet.httpUrl();
  });

  group(HttpMethod.post, () {
    mockRequest() => when(
          () => client.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        );

    void mockResponse(int statusCode,
            {String body = '{"any_key":"any_value"}'}) =>
        mockRequest().thenAnswer((_) async => Response(body, statusCode));

    void mockError() => mockRequest().thenThrow(Exception());

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut.request(
          path: path, method: HttpMethod.post, body: {'any_key': 'any_value'});
      verify(() => client.post(Uri.parse(path),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));

      await sut.request(
          path: path,
          method: HttpMethod.post,
          body: {'any_key': 'any_value'},
          headers: {'any_header': 'any_value'});
      verify(() => client.post(Uri.parse(path),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call post without body', () async {
      await sut.request(path: path, method: HttpMethod.post);

      verify(() => client.post(
            any(),
            headers: any(named: 'headers'),
          ));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(path: path, method: HttpMethod.post);

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return BadRequestError if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(path: path, method: HttpMethod.post);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return UnauthorizedError if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(path: path, method: HttpMethod.post);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return NotFoundError if post returns 403', () async {
      mockResponse(403);

      final future = sut.request(path: path, method: HttpMethod.post);

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError if post returns 404', () async {
      mockResponse(404);

      final future = sut.request(path: path, method: HttpMethod.post);

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if post returns 500', () async {
      mockResponse(500);

      final future = sut.request(path: path, method: HttpMethod.post);

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if post throws', () async {
      mockError();

      final future = sut.request(path: path, method: HttpMethod.post);

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group(HttpMethod.get, () {
    mockRequest() =>
        when(() => client.get(any(), headers: any(named: 'headers')));

    void mockResponse(int statusCode,
            {String body = '{"any_key":"any_value"}'}) =>
        mockRequest().thenAnswer((_) async => Response(body, statusCode));

    void mockError() => mockRequest().thenThrow(Exception());

    setUp(() {
      mockResponse(200);
    });

    test('Should call get with correct values', () async {
      await sut.request(path: path, method: HttpMethod.get);
      verify(() => client.get(Uri.parse(path), headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          }));

      await sut.request(
          path: path,
          method: HttpMethod.get,
          headers: {'any_header': 'any_value'});
      verify(() => client.get(Uri.parse(path), headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          }));
    });

    test('Should return data if get returns 200', () async {
      final response = await sut.request(path: path, method: HttpMethod.get);

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if get returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(path: path, method: HttpMethod.get);

      expect(response, null);
    });

    test('Should return null if get returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(path: path, method: HttpMethod.get);

      expect(response, null);
    });

    test('Should return null if get returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(path: path, method: HttpMethod.get);

      expect(response, null);
    });

    test('Should return BadRequestError if get returns 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(path: path, method: HttpMethod.get);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return BadRequestError if get returns 400', () async {
      mockResponse(400);

      final future = sut.request(path: path, method: HttpMethod.get);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return UnauthorizedError if get returns 401', () async {
      mockResponse(401);

      final future = sut.request(path: path, method: HttpMethod.get);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if get returns 403', () async {
      mockResponse(403);

      final future = sut.request(path: path, method: HttpMethod.get);

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError if get returns 404', () async {
      mockResponse(404);

      final future = sut.request(path: path, method: HttpMethod.get);

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if get returns 500', () async {
      mockResponse(500);

      final future = sut.request(path: path, method: HttpMethod.get);

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if get throws', () async {
      mockError();

      final future = sut.request(path: path, method: HttpMethod.get);

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group(HttpMethod.put, () {
    mockRequest() => when(
          () => client.put(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          ),
        );

    void mockResponse(int statusCode,
            {String body = '{"any_key":"any_value"}'}) =>
        mockRequest().thenAnswer((_) async => Response(body, statusCode));

    void mockError() => mockRequest().thenThrow(Exception());

    setUp(() {
      mockResponse(200);
    });

    test('Should call put with correct values', () async {
      await sut.request(
          path: path, method: HttpMethod.put, body: {'any_key': 'any_value'});
      verify(() => client.put(Uri.parse(path),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));

      await sut.request(
          path: path,
          method: HttpMethod.put,
          body: {'any_key': 'any_value'},
          headers: {'any_header': 'any_value'});
      verify(() => client.put(Uri.parse(path),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call put without body', () async {
      await sut.request(path: path, method: HttpMethod.put);

      verify(() => client.put(any(), headers: any(named: 'headers')));
    });

    test('Should return data if put returns 200', () async {
      final response = await sut.request(path: path, method: HttpMethod.put);

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if put returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(path: path, method: HttpMethod.put);

      expect(response, null);
    });

    test('Should return null if put returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(path: path, method: HttpMethod.put);

      expect(response, null);
    });

    test('Should return null if put returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(path: path, method: HttpMethod.put);

      expect(response, null);
    });

    test('Should return BadRequestError if put returns 400', () async {
      mockResponse(400, body: '');

      final future = sut.request(path: path, method: HttpMethod.put);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return BadRequestError if put returns 400', () async {
      mockResponse(400);

      final future = sut.request(path: path, method: HttpMethod.put);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return UnauthorizedError if put returns 401', () async {
      mockResponse(401);

      final future = sut.request(path: path, method: HttpMethod.put);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError if put returns 403', () async {
      mockResponse(403);

      final future = sut.request(path: path, method: HttpMethod.put);

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError if put returns 404', () async {
      mockResponse(404);

      final future = sut.request(path: path, method: HttpMethod.put);

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if put returns 500', () async {
      mockResponse(500);

      final future = sut.request(path: path, method: HttpMethod.put);

      expect(future, throwsA(HttpError.serverError));
    });

    test('Should return ServerError if put throws', () async {
      mockError();

      final future = sut.request(path: path, method: HttpMethod.put);

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
