import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/auth/login/cubit/login_cubit.dart';
import 'package:flutter_instagram_clone/auth/login/widgets/widgets.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(userRepository: context.read<UserRepository>()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
        child: Column(
          children: [
            //spacing
            const SizedBox(height: AppSpacing.xxxlg * 2),
            //app logo
            const AppLogo(
              fit: BoxFit.fitHeight,
              width: double.infinity,
            ),

            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Login form
                const LoginForm(),

                const Padding(
                  padding: EdgeInsets.only(
                      bottom: AppSpacing.md, top: AppSpacing.xs),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ForgotPasswordButton(),
                  ),
                ),

                //Sign in button

                const SignInButton(),

                //divider with text

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xlg),
                  child: AppDivider(),
                ),

                AuthProviderSignInButton(
                    provider: AuthProvider.google,
                    onPressed: () {
                      context.read<LoginCubit>().loginWithGoogle();
                    }),

                AuthProviderSignInButton(
                    provider: AuthProvider.github, onPressed: () {}),
              ],
            )),

            const SignUpNewAccountButton(),
            ElevatedButton(
                onPressed: () {
                  context.read<UserRepository>().logOut();
                },
                child: const Text("Log Out"))
          ],
        ),
      ),
    );
  }
}
