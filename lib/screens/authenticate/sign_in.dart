import 'package:agrarian_flutter/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[200],
        elevation: 0.0,
        title: const Text('Sign in'),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: ElevatedButton(
              onPressed: () async {
                await _auth.userLogin('craigtipple81@gmail.com', 'P@ssword123');
              },
              child: const Text('Sign In'))),
    );
  }
}
