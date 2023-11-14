import '../../domain/errors/domain_error.dart';
import '../../domain/usecases/remove_post.dart';
import '../http/http_client.dart';

class RemoteRemovePost implements RemovePost {
  final HttpClient httpClient;
  final String path;

  RemoteRemovePost({required this.httpClient, required this.path});

  @override
  Future<bool> remove({required int postId}) async {
    try {
      await httpClient.request(
        path: '$path/$postId',
        method: HttpMethod.delete,
      );
      return true;
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
