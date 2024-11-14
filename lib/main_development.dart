import 'package:database_client/database_client.dart';
import 'package:env/env.dart';
import 'package:flutter_instagram_clone/app/di/di.dart';
import 'package:flutter_instagram_clone/app/view/app.dart';
import 'package:flutter_instagram_clone/bootstrap.dart';
import 'package:flutter_instagram_clone/firebase_options_dev.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:shared/shared.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  // const apiRepository = ApiRepository();
  bootstrap((powersyncRepository) async {
    final iosClientId = getIt<AppFlavor>().getEnv(Env.iOSClientId);
    final webClientId = getIt<AppFlavor>().getEnv(Env.webClientId);
    final tokenStorage = InMemoryTokenStorage();
    final googleSignIn =
        GoogleSignIn(clientId: iosClientId, serverClientId: webClientId);
    final supabaseAuthenticationClient = SupabaseAuthenticationClient(
        powerSyncRepository: powersyncRepository,
        tokenStorage: tokenStorage,
        googleSignIn: googleSignIn);

    final powerSyncDatabaseClient =
        PowerSyncDatabaseClient(powerSyncRepository: powersyncRepository);

    final userRepository = UserRepository(
        authenticationClient: supabaseAuthenticationClient,
        databaseClient: powerSyncDatabaseClient);

    final postsRepository =
        PostsRepository(databaseClient: powerSyncDatabaseClient);

    return App(
      userRepository: userRepository,
      postsRepository: postsRepository,
      user: await userRepository.user.first,
    );
  },
      options: DefaultFirebaseOptions.currentPlatform,
      appFlavor: AppFlavor.development());
}



/// Future<void> bootstrap(AppBuilder builder, {required bool isDev})
/// 
/// AppBuilder => typdef
/// AppBuilder => FutureorWidget Function(PowerSyncRepository)