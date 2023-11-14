import '../../domain/entities/post.dart';
import '../../domain/errors/domain_error.dart';
import '../../domain/usecases/load_posts.dart';
import '../http/http_client.dart';
import '../models/post_model.dart';

class RemoteLoadPosts implements LoadPosts {
  final HttpClient httpClient;
  final String path;

  RemoteLoadPosts({required this.httpClient, required this.path});

  Future<List<PostEntity>> load() async {
    try {
      final response = await httpClient.request(
        path: path,
        method: HttpMethod.get,
      );
      return (response as List)
          .map((json) => PostModel.fromJsonApiPosts(json).toEntity())
          .toList()
        ..sort((a, b) => b.id.compareTo(a.id));
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
