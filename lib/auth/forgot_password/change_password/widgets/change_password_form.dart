// ignore_for_file: always_use_package_imports

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'change_password_field.dart';
import 'change_password_otp_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<ChangePasswordCubit>().resetState();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   context.read<ChangePasswordCubit>().resetState();
  // }

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ChangePasswordOtpField(),
          Gap.v(AppSpacing.md),
          ChangePasswordField(),
        ]);
  }
}
