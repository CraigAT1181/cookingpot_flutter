import 'package:flutter/material.dart';
// import 'package:agrarian_flutter/services/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:agrarian_flutter/screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://piiofkuswklyjlkormfr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBpaW9ma3Vzd2tseWpsa29ybWZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU3MDYyODgsImV4cCI6MjAzMTI4MjI4OH0.Ck_wRVW89LOgr7cvJcwtFXJaDSYHl7m15li-eL7LQH8',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Wrapper(),
    );
  }
}
