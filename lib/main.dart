import 'package:flutter/material.dart';
import 'package:agrarian_flutter/services/supabase.dart';
import 'package:agrarian_flutter/screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Wrapper(),
    );
  }
}
