import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/application/http/http_client.dart';
import 'package:news_app/application/http/http_error.dart';
import 'package:news_app/application/usecases/remote_remove_post.dart';
import 'package:news_app/domain/errors/domain_error.dart';
import 'package:test/test.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  late RemoteRemovePost sut;
  late HttpClientMock httpClient;
  late String path;
  late int postId;

  mockSuccess() => when(
        () => httpClient.request(
          path: any(named: 'path'),
          method: any(named: 'method'),
        ),
      ).thenAnswer(
        (_) async => true,
      );

  mockError(HttpError error) => when(
        () => httpClient.request(
          path: any(named: 'path'),
          method: any(named: 'method'),
        ),
      ).thenThrow(error);

  setUpAll(() {
    registerFallbackValue(HttpMethod.delete);
  });

  setUp(() {
    httpClient = HttpClientMock();
    path = faker.internet.httpUrl();

    sut = RemoteRemovePost(
      httpClient: httpClient,
      path: path,
    );

    postId = faker.randomGenerator.integer(23);

    mockSuccess();
  });

  test('Should call HttpClient with correct values', () async {
    await sut.remove(postId: postId);

    verify(
      () => httpClient.request(
        path: '$path/$postId',
        method: HttpMethod.delete,
      ),
    );
  });

  test('should throw UnexpectedError if HttpClient not return 200', () {
    mockError(HttpError.badRequest);

    final future = sut.remove(postId: postId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
