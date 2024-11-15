// ignore_for_file: public_member_api_docs

import 'package:powersync_repository/powersync_repository.dart' hide User;
import 'package:user_repository/user_repository.dart';

abstract class UserBaseRepository {
  const UserBaseRepository();
  String? get currentUserId;

  Stream<User> profile({required String userId});

  Stream<int> followingsCountOf({required String userId});

  Stream<int> followersCountOf({required String userId});

  Stream<bool> followingStatus({required String userId, String? followerId});

  Future<bool> isFollowed({
    required String userId,
    String? followerId,
  });

  Future<void> follow({required String followToId, String? followerId});

  Future<void> unfollow({required String unfollowId, String? unfollowerId});
}

abstract class PostsBaseRepository {
  const PostsBaseRepository();

  Stream<int> postsAmountOf({required String userId});
}

/// {@template database_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class DatabaseClient
    implements UserBaseRepository, PostsBaseRepository {
  /// {@macro database_client}
  const DatabaseClient();
}

class PowerSyncDatabaseClient extends DatabaseClient {
  const PowerSyncDatabaseClient(
      {required PowerSyncRepository powerSyncRepository})
      : _powerSyncRepository = powerSyncRepository;

  final PowerSyncRepository _powerSyncRepository;

  @override
  String? get currentUserId =>
      _powerSyncRepository.supabase.auth.currentSession?.user.id;

  @override
  Stream<User> profile({required String userId}) {
    //userbase repository
    return _powerSyncRepository
        .db()
        .watch(''' SELECT * FROM profiles WHERE id = ? ''', parameters: [
      userId
    ]).map((event) =>
            event.isEmpty ? User.anonymous : User.fromJson(event.first));
  }

  @override
  Stream<int> postsAmountOf({required String userId}) {
    // from posts repository
    return _powerSyncRepository.db().watch(
        ''' SELECT COUNT(*) as posts_count FROM posts WHERE user_id = ? ''',
        parameters: [userId]).map((event) => event.first['posts_count'] as int);
  }

  @override
  Stream<int> followersCountOf({required String userId}) {
    return _powerSyncRepository.db().watch(
      'SELECT COUNT(*) AS subscription_count FROM subscriptions '
      'WHERE subscribed_to_id = ?',
      parameters: [userId],
    ).map(
      (event) => event.first['subscription_count'] as int,
    );
  }

  @override
  Stream<int> followingsCountOf({required String userId}) {
    return _powerSyncRepository.db().watch(
      'SELECT COUNT(*) AS subscription_count FROM subscriptions '
      'WHERE subscriber_id = ?',
      parameters: [userId],
    ).map(
      (event) => event.first['subscription_count'] as int,
    );
  }


  /// Follows to the user by provided [followToId]. [followerId] is the id
  /// of currently authenticated user.
  @override
  Stream<bool> followingStatus({required String userId, String? followerId}) {
    if (followerId == null && currentUserId == null) {
      return const Stream.empty();
    }
    return _powerSyncRepository.db().watch(
      '''
    SELECT 1 FROM subscriptions WHERE subscriber_id = ? AND subscribed_to_id = ?
    ''',
      parameters: [followerId ?? currentUserId, userId],
    ).map((event) => event.isNotEmpty);
  }

  @override
  Future<bool> isFollowed({
    required String userId,
    String? followerId,
  }) async {
    final result = await _powerSyncRepository.db().execute(
      '''
    SELECT 1 FROM subscriptions WHERE subscriber_id = ? AND subscribed_to_id = ?
    ''',
      [followerId ?? currentUserId, userId],
    );
    return result.isNotEmpty;
  }

  @override
  Future<void> follow({
    required String followToId,
    String? followerId,
  }) async {
    if (currentUserId == null) return;
    if (followToId == currentUserId) return; //no one can follow themselves
    final exists = await isFollowed(
      followerId: followerId ?? currentUserId!,
      userId: followToId,
    );
    if (!exists) {
      await _powerSyncRepository.db().execute(
        '''
          INSERT INTO subscriptions(id, subscriber_id, subscribed_to_id)
            VALUES(uuid(), ?, ?)
      ''',
        [followerId ?? currentUserId!, followToId],
      );
      return;
    }
    await unfollow(
      unfollowId: followToId,
      unfollowerId: followerId ?? currentUserId!,
    );
  }

 @override
  Future<void> unfollow({
    required String unfollowId,
    String? unfollowerId,
  }) async {
    if (currentUserId == null) return;
    await _powerSyncRepository.db().execute(
      '''
          DELETE FROM subscriptions WHERE subscriber_id = ? AND subscribed_to_id = ?
      ''',
      [unfollowerId ?? currentUserId, unfollowId],
    );
  }
}
