import 'package:agrarian_flutter/screens/authenticate/authenticate.dart';
// import 'package:agrarian_flutter/screens/home/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // return either home or authenticate, depending on whether a user is logged in

    return const Authenticate();
  }
}
