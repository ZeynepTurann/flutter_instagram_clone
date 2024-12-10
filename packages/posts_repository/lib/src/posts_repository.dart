import 'package:database_client/database_client.dart';
import 'package:shared/src/models/post.dart';

/// {@template posts_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class PostsRepository extends PostsBaseRepository {
  /// {@macro posts_repository}
  const PostsRepository({required DatabaseClient databaseClient})
      : _databaseClient = databaseClient;

  final DatabaseClient _databaseClient;

  @override
  Stream<int> postsAmountOf({required String userId}) {
    return _databaseClient.postsAmountOf(userId: userId);
  }

  @override
  Future<Post?> createPost(
      {required String id,
      required String caption,
      required String media}) {
    return _databaseClient.createPost(
        id: id, caption: caption, media: media);
  }
}
