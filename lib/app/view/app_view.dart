import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/app/routes/routes.dart';
import 'package:flutter_instagram_clone/app/view/app.dart';
import 'package:flutter_instagram_clone/app/view/app_init_utilities.dart';
import 'package:flutter_instagram_clone/auth/view/auth_page.dart';
import 'package:flutter_instagram_clone/l10n/l10n.dart';
import 'package:flutter_instagram_clone/selector/selector.dart';
import 'package:shared/shared.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = router(context.read<AppBloc>());

    return BlocBuilder<LocaleBloc, Locale>(
      builder: (context, locale) {
        return BlocBuilder<ThemeModeBloc, ThemeMode>(
          builder: (context, themeMode) {
            return AnimatedSwitcher(
              duration: 350.ms,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler
                        .noScaling), //if you change font size on your phone,the font size on Instagram never changes.
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  themeMode: themeMode,
                  theme: const AppTheme().theme,
                  darkTheme: const AppDarkTheme().theme,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  builder: (context, child) {
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => initUtilities(context, locale));
                    return Stack(
                      //bütün ekranlarda snackbar üste gelicek
                      children: [
                        child!,
                        AppSnackbar(
                          key: snackbarKey,
                        ),
                        AppLoadingIndeterminate(
                          key: loadingIndeterminateKey,
                        )
                      ],
                    );
                  },
                  routerConfig: routerConfig,
                  locale: locale,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
