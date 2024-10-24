import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/auth/auth.dart';


class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///form fields

        //email

        EmailFormField(),

        SizedBox(height: AppSpacing.md),

        //fullname

        FullNameFormField(),

        SizedBox(height: AppSpacing.md),

        //username
        UsernameFormField(),

        SizedBox(height: AppSpacing.md),
        //password

        PasswordFormField(),

      ],
    );
  }
}
