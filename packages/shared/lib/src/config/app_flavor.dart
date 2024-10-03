//currently flavor, for example we are in the development environment,the app will know that our flavor is development

// ignore_for_file: public_member_api_docs
import 'package:env/env.dart';

enum Flavor { development, staging, production }

///hiç bir class bundan türeyemez bu file dısındaki
sealed class AppEnv {
  const AppEnv();

  String getEnv(Env env);
}

class AppFlavor extends AppEnv {
  const AppFlavor._({required this.flavor});

  factory AppFlavor.development() =>
      const AppFlavor._(flavor: Flavor.development);

  factory AppFlavor.staging() => const AppFlavor._(flavor: Flavor.staging);

  factory AppFlavor.production() =>
      const AppFlavor._(flavor: Flavor.production);

  final Flavor flavor;

  @override
  String getEnv(Env env) => switch (env) {
        Env.supabaseUrl => switch (flavor) {
            Flavor.development => EnvDev.supabaseUrl,
            Flavor.production => EnvProd.supabaseUrl,
            Flavor.staging => EnvStaging.supabaseUrl
          },
        Env.powersyncUrl => switch (flavor) {
            Flavor.development => EnvDev.powersyncUrl,
            Flavor.production => EnvProd.powersyncUrl,
            Flavor.staging => EnvStaging.powersyncUrl
          },
        Env.supabaseAnonKey => switch (flavor) {
            Flavor.development => EnvDev.supabaseAnonKey,
            Flavor.production => EnvProd.supabaseAnonKey,
            Flavor.staging => EnvStaging.supabaseAnonKey
          },
        Env.webClientId => switch (flavor) {
            Flavor.development => EnvDev.webClientId,
            Flavor.production => EnvProd.webClientId,
            Flavor.staging => EnvStaging.webClientId
          },
        Env.iOSClientId => switch (flavor) {
            Flavor.development => EnvDev.iOSClientId,
            Flavor.production => EnvProd.iOSClientId,
            Flavor.staging => EnvStaging.iOSClientId
          }
      };
}

/// bu dosya dısındaki dosyalarda kullanım bu şekilde
/// bu file dısında AppFlavor classından instance alınamaz gibi bi durum oldu

// AppFlavor development = AppFlavor.development();

///we can use getEnv() function inside of the AppFlavor class