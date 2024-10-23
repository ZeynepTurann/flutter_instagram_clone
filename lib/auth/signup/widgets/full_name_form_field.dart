import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/auth/signup/sign_up.dart';

import 'package:flutter_instagram_clone/l10n/l10n.dart';

import 'package:shared/shared.dart';

class FullNameFormField extends StatefulWidget {
  const FullNameFormField({super.key});

  @override
  State<FullNameFormField> createState() => _FullNameFormFieldState();
}

class _FullNameFormFieldState extends State<FullNameFormField> {
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
      context.read<SignUpCubit>().onFullNameUnfocused();
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

    final fullNameError = context
        .select((SignUpCubit cubit) => cubit.state.fullName.errorMessage);

    return AppTextField(
        filled: true,
        errorText: fullNameError,
        enabled: !isLoading,
        focusNode: _focusNode,
        hintText: context.l10n.nameText,
        autofillHints: const [AutofillHints.givenName],
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        onChanged: (value) => _debouncer.run(() {
              context.read<SignUpCubit>().onFullNameChanged(value);
            }));
  }
}
