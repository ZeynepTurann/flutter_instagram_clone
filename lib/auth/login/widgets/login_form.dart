import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/auth/login/widgets/email_form_field.dart';
import 'package:flutter_instagram_clone/auth/login/widgets/password_form_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmailFormField(),
        SizedBox(
          height: AppSpacing.md,
        ),
        PasswordFormField(),
        SizedBox(
          height: AppSpacing.md,
        ),
      ],
    );
  }
}
