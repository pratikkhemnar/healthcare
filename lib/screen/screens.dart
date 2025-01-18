import 'package:flutter/material.dart';
import 'dart:async';
import 'package:healthcare/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after 3 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your target screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Color or Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Center Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Healthcare-Themed Logo
                Image.asset(
                  'assets/images/bot2.png', // Replace with your healthcare logo
                  height: 300,
                  width: 500,
                ),
                const SizedBox(height: 20),
                // App Name or Tagline
                const Text(
                  'HealthCare Plus',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your health, our priority',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Footer
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 10),
                Text(
                  'Loading your healthcare assistant...',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

