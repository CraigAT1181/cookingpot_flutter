import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  late SupabaseClient supabase;

  Future<void> initialize() async {
    await Supabase.initialize(
        url: 'https://piiofkuswklyjlkormfr.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBpaW9ma3Vzd2tseWpsa29ybWZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU3MDYyODgsImV4cCI6MjAzMTI4MjI4OH0.Ck_wRVW89LOgr7cvJcwtFXJaDSYHl7m15li-eL7LQH8');
    supabase = Supabase.instance.client;
  }
}
