import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuku_fm/pages/homeScreen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      duration: 3000,
      navigateRoute: Homescreen(),
      imageSrc: "assets/image/headphones-listening.svg.png",
      backgroundColor: Colors.black12,
      text: "Welcome to Bajan Songs!",
      textType: TextType.NormalText,
      textStyle: TextStyle(
        fontSize: 20.0,
        color: CupertinoColors.white,
      ),
      // Optional: You can add more customizations as needed
    );
  }
}