// ignore_for_file: comment_references, always_put_required_named_parameters_first

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/app/view/app_view.dart';
import 'package:flutter_instagram_clone/selector/locale/locale.dart';
import 'package:flutter_instagram_clone/selector/selector.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:user_repository/user_repository.dart';

///Key to access the [AppSnackBarState] from the [BuildContext],
final snackbarKey = GlobalKey<AppSnackbarState>();

class App extends StatelessWidget {
  const App(
      {super.key,
      required this.userRepository,
      required this.user,
      required this.postsRepository});

  final User user;
  final UserRepository userRepository;
  final PostsRepository postsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: userRepository,
        ),
        RepositoryProvider.value(
          value: postsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AppBloc(user: user, userRepository: userRepository),
          ),
          BlocProvider(
            create: (context) => LocaleBloc(),
          ),
          BlocProvider(
            create: (context) => ThemeModeBloc(),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

/// Snack bar to show messages to the user.
void openSnackbar(
  SnackbarMessage message, {
  bool clearIfQueue = false,
  bool undismissable = false,
}) {
  snackbarKey.currentState
      ?.post(message, clearIfQueue: clearIfQueue, undismissable: undismissable);
}

// void toggleLoadingIndeterminate({bool enable = true, bool autoHide = false}) =>
//     loadingIndeterminateKey.currentState
//         ?.setVisibility(visible: enable, autoHide: autoHide);

/// Closes all snack bars.
void closeSnackbars() => snackbarKey.currentState?.closeAll();
