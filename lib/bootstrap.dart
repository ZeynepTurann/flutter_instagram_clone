import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_instagram_clone/app/di/di.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';

typedef AppBuilder = FutureOr<Widget> Function(PowerSyncRepository);

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logD('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logD('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}
//required FirebaseOptions options

Future<void> bootstrap(
  AppBuilder builder, {
  required FirebaseOptions options,
  required AppFlavor appFlavor,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      setUpDi(appFlavor: appFlavor);

      await Firebase.initializeApp(options: options);


      // providing a solution to persist and restore the application’s state 
      //even after restarting the app.
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getTemporaryDirectory(),
      );

      // final powerSyncRepository = PowerSyncRepository(env: appFlavor.getEnv);
      final powerSyncRepository = PowerSyncRepository(env: appFlavor.getEnv);
      await powerSyncRepository.initialize();

      // final firebaseMessaging = FirebaseMessaging.instance;
      // FirebaseMessaging.onBackgroundMessage(
      //   _firebaseMessagingBackgroundHandler,
      // );

      // final sharedPreferences = await SharedPreferences.getInstance();

      // final firebaseRemoteConfig = FirebaseRemoteConfig.instance;
      // final firebaseRemoteConfigRepository = FirebaseRemoteConfigRepository(
      //   firebaseRemoteConfig: firebaseRemoteConfig,
      // );

      //portrait mode
      SystemUiOverlayTheme.setPortraitOrientation(); 

      runApp(await builder(powerSyncRepository)
          // TranslationProvider(
          //   child: await builder(
          //     powerSyncRepository,
          //     firebaseMessaging,
          //     sharedPreferences,
          //     firebaseRemoteConfigRepository,
          //   ),
          // ),
          );
    },
    (error, stack) {
      logE(error.toString(), stackTrace: stack);
    },
  );
}
