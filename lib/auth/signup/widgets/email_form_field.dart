import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/auth/signup/sign_up.dart';

import 'package:flutter_instagram_clone/l10n/l10n.dart';

import 'package:shared/shared.dart';

class EmailFormField extends StatefulWidget {
  const EmailFormField({super.key});

  @override
  State<EmailFormField> createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  late Debouncer _debouncer;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(_focusNodeListener); // _focusNode.addListener()
    _debouncer = Debouncer();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      context.read<SignUpCubit>().onEmailUnfocused();
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context
        .select((SignUpCubit cubit) => cubit.state.submissionStatus.isLoading);

    final emailError =
        context.select((SignUpCubit cubit) => cubit.state.email.errorMessage);

    return AppTextField(
        filled: true,
        errorText: emailError,
        enabled: !isLoading,
        focusNode: _focusNode,
        hintText: context.l10n.emailText,
        autofillHints: const [AutofillHints.email],
        textInputType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: (value) => _debouncer.run(() {
              context.read<SignUpCubit>().onEmailChanged(value);
            }));
  }
}
