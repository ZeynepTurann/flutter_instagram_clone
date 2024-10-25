import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:flutter_instagram_clone/auth/login/cubit/login_cubit.dart';
import 'package:shared/shared.dart';

class EmailFormFieldLogIn extends StatefulWidget {
  const EmailFormFieldLogIn({super.key});

  @override
  State<EmailFormFieldLogIn> createState() => _EmailFormFieldLogInState();
}

class _EmailFormFieldLogInState extends State<EmailFormFieldLogIn> {
  late Debouncer _debouncer;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _focusNode = FocusNode()
      ..addListener(_focusNodeListener); // _focusNode.addListener()
    _debouncer = Debouncer();
  }

  void _focusNodeListener() {
    if (!_focusNode.hasFocus) {
      context.read<LoginCubit>().onEmailUnfocused();
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_focusNodeListener)
      ..dispose();
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var emailError =
        context.select((LoginCubit cubit) => cubit.state.email.errorMessage);

    return AppTextField(
        filled: true,
        errorText: emailError,
        textController: _controller,
        focusNode: _focusNode,
        hintText: context.l10n.emailText,
        textInputType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: (value) => _debouncer.run(() {
              context.read<LoginCubit>().onEmailChanged(value);
            }));
  }
}
