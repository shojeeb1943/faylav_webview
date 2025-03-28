import 'package:flutter/material.dart';
import 'dart:async';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  late Timer _timer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startNavTimer();
  }

  void _startNavTimer() {
    // Navigate to the WebView after a delay with try/catch for safety
    _timer = Timer(const Duration(seconds: 2), () {
      _navigateToWebView();
    });
  }

  void _navigateToWebView() {
    if (_navigated || !mounted) return;

    try {
      setState(() {
        _navigated = true;
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WebViewScreen()),
      );
    } catch (e) {
      debugPrint('Error navigating from splash screen: $e');
      // If navigation failed, try again with a different approach after a short delay
      if (mounted && !_navigated) {
        Timer(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WebViewScreen()),
            (route) => false,
          );
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_navigated) {
      // If app resumed and we haven't navigated yet, try to navigate
      _navigateToWebView();
    }
  }

  @override
  void dispose() {
    // Cancel timer to prevent memory leaks
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async => false, // Prevent back navigation during splash
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Arabic Faylav text
              const Text(
                'فايلاف',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF3399), // Faylav pink color
                ),
              ),
              const SizedBox(height: 10),

              // English Faylav text
              const Text(
                'FAYLAV',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF3399), // Faylav pink color
                ),
              ),

              const SizedBox(height: 40),

              // Loading indicator
              const CircularProgressIndicator(
                color: Color(0xFFFF3399), // Faylav pink color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
