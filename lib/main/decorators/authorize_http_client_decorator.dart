import 'package:news_app/application/http/http_client.dart';
import 'package:news_app/application/http/http_error.dart';
import 'package:news_app/application/storage/local_storage.dart';
import 'package:news_app/domain/usecases/load_current_account.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final LoadCurrentAccount loadCurrentAccount;
  final HttpClient decoratee;
  final CacheLocalStorage localStorage;

  AuthorizeHttpClientDecorator({
    required this.loadCurrentAccount,
    required this.decoratee,
    required this.localStorage,
  });

  Future<dynamic> request({
    required String path,
    required HttpMethod method,
    Map? body,
    Map? headers,
  }) async {
    try {
      final account = await loadCurrentAccount.load();
      if (account == null) {
        throw HttpError.forbidden;
      }

      final authorizedHeaders = headers ?? {}
        ..addAll({'Authorization': 'Bearer ${account.token}'});

      final bodyUser = {
        "users_permissions_user": {
          "id": "${account.id}",
        }
      };
      body?..addAll(bodyUser);

      return await decoratee.request(
        path: path,
        method: method,
        body: body,
        headers: authorizedHeaders,
      );
    } catch (error) {
      if (error is HttpError && error != HttpError.forbidden) {
        rethrow;
      } else {
        await localStorage.clear();
        throw HttpError.forbidden;
      }
    }
  }
}
