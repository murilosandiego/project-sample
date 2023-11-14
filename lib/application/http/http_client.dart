enum HttpMethod { post, get, put, delete }

abstract class HttpClient {
  Future<dynamic> request({
    required String path,
    required HttpMethod method,
    Map? body,
    Map? headers,
  });
}
