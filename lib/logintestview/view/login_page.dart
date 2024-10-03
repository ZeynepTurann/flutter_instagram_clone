import 'package:app_ui/app_ui.dart';
import 'package:env/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/app/di/di.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GoogleSignInButton(),
        const SizedBox(
          height: 10,
        ),
        const LogOutButton()
      ],
              ),
            ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  GoogleSignInButton({super.key});

  ///currently flavor is development mode so EnvDev.webClientId
  ///currently flavor is development mode so EnvDev.iosClientId
  ///these values are obtained via google cloud console and stored as an environmental variables in env package in the project

  final webClientId = getIt<AppFlavor>().getEnv(Env.webClientId);
  final iosClientId = getIt<AppFlavor>().getEnv(Env.iOSClientId);

  Future<void> _googleSignIn() async {
    final googleSignIn =
        GoogleSignIn(clientId: iosClientId, serverClientId: webClientId);

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    if (googleAuth == null) {
      // logW('google sign in was canceled.');
      throw Exception('Google sign in was canceled');
    }
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;
    if (accessToken == null) {
      throw Exception('No access token found');
    }
    if (idToken == null) {
      throw Exception('No access token found');
    }
    await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () async {
          try {
            await _googleSignIn();
          } catch (error) {
            logE('Failed to login with Google', error: error);
          }
        },
        icon: Assets.icons.google.svg(height: 32),
        label: Text(
          'Google Sign in',
          style: Theme.of(context).textTheme.headlineSmall,
        ));
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  void _logOut() {
    Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final session = snapshot.data!.session;
            if (session == null) return const SizedBox.shrink();
            return ElevatedButton.icon(
                onPressed: _logOut,
                icon: const Icon(Icons.logout),
                label: Text(
                  'Log out',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.red),
                ));
          }
          return const SizedBox.shrink();
        });
  }
}



//tıklanabilir widget componenti olusturma
 // Tappable.raw(
    //     // variant: TappableVariant.scaled, //normal,faded,scaled
    //     // scaleStrength: ScaleStrength.xxs,
    //     // scaleAlignment: Alignment.centerLeft,
    //     variant: TappableVariant.faded,
    //     fadeStrength: FadeStrength.lg,
    //     backgroundColor: context.theme.focusColor,
    //     borderRadius: BorderRadius.circular(12),
    //     onTap: () async {
    //       // try {
    //       //   await _googleSignIn();
    //       // } catch (error) {
    //       //   logE('Failed to login with Google', error: error);
    //       // }
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(
    //           horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    //       child: Text(
    //         'Google Sign in',
    //         style: Theme.of(context).textTheme.headlineSmall,
    //       ),
    //     ));