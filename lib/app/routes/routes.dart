// ignore_for_file: prefer_single_quotes, prefer_const_constructors

import 'dart:async';

import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/view/app_view.dart';
import 'package:flutter_instagram_clone/auth/view/auth_page.dart';
import 'package:flutter_instagram_clone/home/home.dart';
import 'package:flutter_instagram_clone/user_profile/user_profile.dart';

import 'package:go_router/go_router.dart';

import '../bloc/app_bloc.dart';

final _rooutNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "root");

//always need a default location
GoRouter router(AppBloc appBloc) {
  return GoRouter(
      navigatorKey: _rooutNavigatorKey,
      initialLocation: '/feed',
      routes: [
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthPage(),
        ),
        GoRoute(
            parentNavigatorKey: _rooutNavigatorKey,
            path: '/route',
            builder: (context, state) => AppScaffold(
                    body: Center(
                  child: Text("I am route"),
                ))),
        StatefulShellRoute.indexedStack(
            parentNavigatorKey: _rooutNavigatorKey,
            //each statefulshellbranch represents a bottom nav bar item:)
            builder: (context, state, navigationShell) {
              return HomePage(navigationShell: navigationShell);
            },
            branches: [
              StatefulShellBranch(routes: [
                GoRoute(
                  path: '/feed',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      child: AppScaffold(
                          body: Center(
                              child: ElevatedButton(
                                  onPressed: () => context.push('/route'),
                                  child: Text("Go Route")))),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                          child: child,
                        );
                      },
                    );
                  },
                )
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                  path: '/timeline',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      child: AppScaffold(
                          body: Center(
                              child: Text(
                        "Timeline",
                        style: context.headlineSmall,
                      ))),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOut)
                              .animate(animation),
                          child: child,
                        );
                      },
                    );
                  },
                )
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                  path: '/create_media',
                  redirect: (context, state) => null,
                )
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                  path: '/reels',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      child: AppScaffold(
                          body: Center(
                              child: Text(
                        "Reels",
                        style: context.headlineSmall,
                      ))),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurveTween(curve: Curves.easeInOut)
                              .animate(animation),
                          child: child,
                        );
                      },
                    );
                  },
                )
              ]),
              StatefulShellBranch(routes: [
                GoRoute(
                  path: '/user',
                  pageBuilder: (context, state) {
                    final user =
                        context.select((AppBloc bloc) => bloc.state.user);

                    return CustomTransitionPage(
                      child: UserProfilePage(userId: user.id),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                          child: child,
                        );
                      },
                    );
                  },
                )
              ]),
            ])
      ],
      redirect: (context, state) {
        final authenticated = appBloc.state.status == AppStatus.authenticated;
        final authenticating = state.matchedLocation == '/auth';
        final isInFeed = state.matchedLocation == '/feed';

        if (isInFeed && !authenticated) return '/auth';
        if (!authenticated) return '/auth';
        if (authenticating && authenticated) return '/feed';

        return null;
      },
      refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream));
}

/// {@template go_router_refresh_stream}
/// A [ChangeNotifier] that notifies listeners when a [Stream] emits a value.
/// This is used to rebuild the UI when the [AppBloc] emits a new state.
/// {@endtemplate}
class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  /// {@macro go_router_refresh_stream}
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((appState) {
      if (_appState == appState) return;
      notifyListeners();
    });
  }

  final AppState _appState = const AppState.unauthenticated();

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
