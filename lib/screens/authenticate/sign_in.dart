import 'package:agrarian_flutter/services/auth.dart';
import 'package:agrarian_flutter/shared/constants.dart';
import 'package:agrarian_flutter/shared/loading.dart';
import 'package:agrarian_flutter/shared/primary_button.dart';
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

  String error = '';
  bool loading = false;

  Future handleSignIn() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        await _auth.userLogin(email, password);
      } catch (e) {
        setState(() {
          error =
              "Oops, something went wrong! Please check your details and try again.";
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.green[800],
              foregroundColor: Colors.white,
              elevation: 0.0,
              title: const Text('Welcome back!'),
              actions: <Widget>[
                const Icon(Icons.person),
                TextButton(
                    onPressed: () => widget.toggleView(),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: const Text('Register')),
              ],
            ),
            body: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
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
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
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
                      PrimaryButton(onPressed: handleSignIn, text: 'Sign in'),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                )),
          );
  }
}
