import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun3/service/sharedPref.dart';

import '../service/Auth.dart';
import 'home.dart';
import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    delayNav();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void delayNav() async {
    await Future.delayed(const Duration(milliseconds: 300));
    String result = await SharedPref.getLoggedUserID();
    if (result.isNotEmpty) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage(userID: result)));
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("assets/icon.png", width: 200, height: 200),
    );
  }
}
