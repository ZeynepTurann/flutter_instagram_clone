import 'package:api_repository/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/view/app_view.dart';

class App extends StatelessWidget {
  const App({super.key, required this.apiRepository});

  final ApiRepository apiRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: apiRepository,
      child: const AppView(),
    );
  }
}
