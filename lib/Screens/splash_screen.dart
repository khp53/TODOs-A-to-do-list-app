import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'home.dart';


class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        navigateAfterSeconds: Home(),
        image: Image.asset('assets/logo.png'),
        backgroundColor: Color(0xff394D97),
        photoSize: 100.0,
        loaderColor: Color(0xff394D97),
    );
  }
}
