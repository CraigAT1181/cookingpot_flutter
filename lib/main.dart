import 'package:agrarian_flutter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:agrarian_flutter/services/supabase.dart';
import 'package:agrarian_flutter/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:agrarian_flutter/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().authStateChanges,
      initialData: null,
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
