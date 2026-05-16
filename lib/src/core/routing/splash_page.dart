import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F5F0),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF1A1714),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
