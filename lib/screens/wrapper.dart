import 'package:agrarian_flutter/screens/authenticate/authenticate.dart';
import 'package:agrarian_flutter/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agrarian_flutter/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // return either home or authenticate, depending on whether a user is logged in

    final user = Provider.of<User?>(context);

    if (user is User) {
      // Could also use if user == null return Authenticate()
      return Home();
    } else {
      return const Authenticate();
    }
  }
}
