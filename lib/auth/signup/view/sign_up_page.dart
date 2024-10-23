import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/auth/auth.dart';
import 'package:instagram_blocks_ui/instagram_blocks_ui.dart';
import 'package:user_repository/user_repository.dart';

import '../widgets/sign_in_into_account_button.dart';
import '../widgets/sign_up_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignUpCubit(userRepository: context.read<UserRepository>()),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        releaseFocus: true,
        resizeToAvoidBottomInset: true,
        body: AppConstrainedScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
            child: Column(
              children: [
                SizedBox(height: AppSpacing.xxxlg * 1.5),
                AppLogo(fit: BoxFit.fitHeight),
                Expanded(
                    child: Column(
                  children: [
                    AvatarImagePicker(),
                    SizedBox(height: AppSpacing.md),
                    SignUpForm(),
                    SizedBox(
                      height: AppSpacing.xlg,
                    ),
                    SignUpButton()
                  ],
                )),

                //login in account button
                SignInIntoAccountButton()
              ],
            )));
  }
}
