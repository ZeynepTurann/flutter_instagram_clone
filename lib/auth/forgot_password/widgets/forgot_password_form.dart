import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/auth/forgot_password/widgets/forgot_password_email_form_field.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ForgotPasswordEmailFormField()],
    );
  }
}
