import 'dart:async';
import 'package:Boatify/screens/GetStart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Boatify/components/Bottomnav.dart';
import '../components/colors.dart'; // Custom colors if you have them

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;
  Timer? _timer;
  Timer? _textTimer;
  int _animationCount = 0; // To count the fade cycles
  int _dotCount = 0; // To animate the dots
  String _loadingText = "Boatify";

  @override
  void initState() {
    super.initState();
    _startFadeAnimation();
    _startTextAnimation();
  }

  void _startFadeAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        _opacity = _opacity == 1.0 ? 0.3 : 1.0;
      });

      _animationCount++;

      // Stop the animation and check authentication after 3 cycles
      if (_animationCount >= 3) {
        _timer?.cancel();
        _checkAuthStatus();
      }
    });
  }

  void _startTextAnimation() {
    _textTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;
      setState(() {
        _dotCount = (_dotCount + 1) % 4; // Cycle through 0, 1, 2, 3
        _loadingText = "Boatify${'.' * _dotCount}";
      });
    });
  }

  // Function to check Firebase authentication status
  void _checkAuthStatus() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Small delay for smooth transition

    User? user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => user != null ? BottomNav() : Getstart(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Ensure the timer is canceled to prevent memory leaks
    _textTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.White,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 1),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Boatify.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _loadingText, // Animated text
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.Black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
