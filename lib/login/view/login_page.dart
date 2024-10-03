import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/login/cubit/login_cubit.dart';
import 'package:flutter_instagram_clone/login/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      releaseFocus: true,
      body: Column(
        children: [
          //spacing
          SizedBox(height: AppSpacing.xxxlg * 2),
          //app logo
          AppLogo(
            fit: BoxFit.fitHeight,
            width: double.infinity,
          ),

          Expanded(
              child: Column(
            children: [
              //Login form

              LoginForm()
            ],
          ))
        ],
      ),
    );
  }
}
