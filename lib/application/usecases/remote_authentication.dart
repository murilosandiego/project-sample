import '../../domain/entities/account.dart';
import '../../domain/errors/domain_error.dart';
import '../../domain/usecases/authentication.dart';
import '../http/http_client.dart';
import '../http/http_error.dart';
import '../models/account_model.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String path;

  RemoteAuthentication({
    required this.httpClient,
    required this.path,
  });

  @override
  Future<Account> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();

    try {
      final httpResponse = await httpClient.request(
        path: path,
        method: HttpMethod.post,
        body: body,
      );
      return AccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.secret,
      );

  Map toJson() => {'email': email, 'password': password};
}
