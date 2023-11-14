import '../entities/post.dart';

abstract class LoadPosts {
  Future<List<PostEntity>> load();
}
