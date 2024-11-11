import 'package:flutter_instagram_clone/auth/view/auth_page.dart';
import 'package:go_router/go_router.dart';

//always need a default location
GoRouter router() {
  return GoRouter(initialLocation: '/auth', routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthPage(),
    ),

    // StatefulShellRoute.indexedStack(
    //   branches: branches
    //   )
  ]);
}
