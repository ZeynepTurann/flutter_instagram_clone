import 'package:envied/envied.dart';

part 'env.stg.g.dart';

@Envied(path: '.env.staging', obfuscate: true)
abstract class EnvStaging{

  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static  String supabaseUrl = _EnvStaging.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static  String supabaseAnonKey = _EnvStaging.supabaseAnonKey;

  @EnviedField(varName: 'POWERSYNC_URL', obfuscate: true)
  static  String powersyncUrl = _EnvStaging.powersyncUrl;

  @EnviedField(varName: 'WEB_CLIENT_ID', obfuscate: true)
  static  String webClientId = _EnvStaging.webClientId;

  @EnviedField(varName: 'IOS_CLIENT_ID', obfuscate: true)
  static  String iOSClientId = _EnvStaging.iOSClientId;
}