import 'package:flutter/material.dart';
import 'package:ifms/screens/MLDashboardScreen.dart';
import 'package:ifms/screens/farmers/MLLoginScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ifms/utils/MLImage.dart';

class MLSplashScreen extends StatefulWidget {
  @override
  _MLSplashScreenState createState() => _MLSplashScreenState();
}

class _MLSplashScreenState extends State<MLSplashScreen> {
  @override
  void initState() {
    super.initState();
    //
    init();
  }

  Future<void> init() async {
    await 1.seconds.delay;
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      // Navigate to the HomeScreen if logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MLDashboardScreen()), // Replace with your home screen widget
      );
    } else {
      // Navigate to the LoginScreen if not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MLLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'images/logo_farmexceed.png',
        height: 150,
        width: 150,
      ).center(),
    );
  }
}
