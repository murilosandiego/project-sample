import '../../../application/usecases/remote_authentication.dart';
import '../../../domain/usecases/authentication.dart';
import '../api_url_factory.dart';
import '../http/http_client_factory.dart';

class AuthenticationFactory {
  static Authentication makeRemoteAuthentication() => RemoteAuthentication(
        httpClient: HttpClientFactory.makeHttpClientAdapter(),
        path: makeApiUrl('authentication'),
      );
}
