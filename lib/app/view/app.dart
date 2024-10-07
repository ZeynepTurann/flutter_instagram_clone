
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/view/app_view.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({super.key,required this.userRepository});



  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: userRepository,
      child: const AppView(),
    );
  }
}
