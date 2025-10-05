import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://oaomwxprbprgsihdvaxk.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9hb213eHByYnByZ3NpaGR2YXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM0Mjk0MDcsImV4cCI6MjA2OTAwNTQwN30.vUzBhG8t3syeoWaU57GyrnzITxpVidlt5chTvLpOK00';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }
}