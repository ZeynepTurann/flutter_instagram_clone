import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:instagram_blocks_ui/instagram_blocks_ui.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignUpView();
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
                AvatarImagePicker()
              ],
            )));
  }
}
