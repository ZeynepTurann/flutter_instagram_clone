import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/app/view/app.dart';
import 'package:flutter_instagram_clone/auth/view/auth_page.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: const AppTheme().theme,
        darkTheme: const AppDarkTheme().theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          return Stack(
            //bütün ekranlarda snackbar üste gelicek
            children: [
              child!,
              AppSnackbar(
                key: snackbarKey,
              ),
            ],
          );
        },
        home: const AuthPage());
  }
}
