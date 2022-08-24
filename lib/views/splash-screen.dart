import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_ids/views/home.dart';
// import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatefulWidget {
  // const SplashScreen({Key? key, required this.fbApp}) : super(key: key);
  // final FirebaseApp fbApp;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  late final FirebaseApp fbApp;

  _navigateToHome() async {
    fbApp = await Firebase.initializeApp();
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.asset(
              "assets/images/logo-pic.png",
              fit: BoxFit.fitHeight,
              height: 200,
              width: 200,
            ),
          ),
          Text(
            'IDS',
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
