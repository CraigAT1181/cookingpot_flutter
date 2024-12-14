import 'package:agrarian_flutter/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.toggleView});

  final Function toggleView;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[200],
        elevation: 0.0,
        title: const Text('Welcome back!'),
        actions: <Widget>[
          TextButton(
              onPressed: () => widget.toggleView(),
              style: TextButton.styleFrom(foregroundColor: Colors.brown[800]),
              child: const Text('Register')),
        ],
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter an email address.'
                      : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  validator: (value) => value == null || value.length < 6
                      ? 'Please ensure password is at least 6 characters long.'
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.brown[400]),
                    onPressed: () async {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate()) {
                        await _auth.userLogin(email, password);
                      }
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          )),
    );
  }
}
