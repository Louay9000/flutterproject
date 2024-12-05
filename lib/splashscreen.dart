import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignInScreen.dart';
import 'home.dart';

class splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    Future.delayed(Duration(seconds: 10), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; 

      if (isLoggedIn) {
      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }
    });   
    
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Center(
        child: Lottie.network(
          'https://lottie.host/2bd1318d-354c-44a7-a6f3-ec3c3012a173/rHYlAvW0Fm.json',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,

        ),
      ),
    );
  }
}