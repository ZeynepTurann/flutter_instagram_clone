// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo(
      {super.key,
      this.width,
      this.height,
      required this.fit,
      this.color});

  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Assets.images.instagramTextLogo.svg(
        height: height ?? 50,
        width: width ?? 50,
        fit: fit,
        colorFilter:
            ColorFilter.mode(color ?? context.adaptiveColor, BlendMode.srcIn));
  }
}
