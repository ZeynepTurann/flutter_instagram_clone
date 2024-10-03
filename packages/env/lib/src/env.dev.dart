import 'package:envied/envied.dart';

part 'env.dev.g.dart';

@Envied(path: '.env.dev', obfuscate: true)
abstract class EnvDev{

  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static  String supabaseUrl = _EnvDev.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static  String supabaseAnonKey = _EnvDev.supabaseAnonKey;

  @EnviedField(varName: 'POWERSYNC_URL', obfuscate: true)
  static  String powersyncUrl = _EnvDev.powersyncUrl;

  @EnviedField(varName: 'WEB_CLIENT_ID', obfuscate: true)
  static  String webClientId = _EnvDev.webClientId;

  @EnviedField(varName: 'IOS_CLIENT_ID', obfuscate: true)
  static  String iOSClientId = _EnvDev.iOSClientId;
}


//These are secret variables 
//dev mode our application
