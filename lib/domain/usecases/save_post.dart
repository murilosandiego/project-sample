import '../entities/post.dart';

abstract class SavePost {
  Future<PostEntity> save({required String message, int? postId});
}
