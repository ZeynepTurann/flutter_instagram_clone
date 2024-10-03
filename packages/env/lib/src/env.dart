// ignore_for_file: public_member_api_docs

enum Env {
  supabaseUrl('SUPABASE_URL'),
  powersyncUrl('POWERSYNC_URL'),
  iOSClientId('IOS_CLIENT_ID'),
  webClientId('WEB_CLIENT_ID'),
  supabaseAnonKey('SUPABASE_ANON_KEY');

  const Env(this.value);

  final String value;
}
