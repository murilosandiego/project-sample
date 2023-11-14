import '../../domain/entities/post.dart';
import '../../domain/errors/domain_error.dart';
import '../../domain/usecases/save_post.dart';
import '../http/http_client.dart';
import '../models/post_model.dart';

class RemoteSavePost implements SavePost {
  final HttpClient httpClient;
  final String path;

  RemoteSavePost({
    required this.httpClient,
    required this.path,
  });

  @override
  Future<PostEntity> save({required String message, int? postId}) async {
    final body = {"content": message};
    try {
      final httpResponse = await httpClient.request(
        path: postId == null ? path : '$path/$postId',
        method: postId == null ? HttpMethod.post : HttpMethod.put,
        body: body,
      );

      return PostModel.fromJsonApiPosts(httpResponse).toEntity();
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
