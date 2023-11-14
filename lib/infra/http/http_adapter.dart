import 'dart:convert';

import 'package:http/http.dart';

import '../../application/http/http_client.dart';
import '../../application/http/http_error.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<dynamic> request({
    required String path,
    required HttpMethod method,
    Map? body,
    Map? headers,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll(
          {'content-type': 'application/json', 'accept': 'application/json'});
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);
    late Future<Response> futureResponse;

    try {
      switch (method) {
        case HttpMethod.post:
          futureResponse = client.post(Uri.parse(path),
              headers: defaultHeaders, body: jsonBody);
          break;
        case HttpMethod.get:
          futureResponse = client.get(Uri.parse(path), headers: defaultHeaders);
          break;
        case HttpMethod.put:
          futureResponse = client.put(Uri.parse(path),
              headers: defaultHeaders, body: jsonBody);
          break;
        case HttpMethod.delete:
          futureResponse =
              client.delete(Uri.parse(path), headers: defaultHeaders);
          break;
        default:
          throw HttpError.serverError;
      }
      response = await futureResponse.timeout(Duration(seconds: 30));
    } catch (error) {
      throw HttpError.serverError;
    }
    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isEmpty ? null : jsonDecode(response.body);
      case 201:
        return response.body.isEmpty ? null : jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        throw HttpError.unauthorized;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      default:
        throw HttpError.serverError;
    }
  }
}
