import 'package:flutter/material.dart';
import 'pairing_screen.dart'; // reuse existing pairing flow

/// Splash/Welcome screen that handles the initial delay before moving to the main app flow.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static const routeName = '/welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context)
            .pushReplacementNamed(PairingScreen.routeName); // changed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = ((ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>?)?['title'] as String?) ??
        'Welcome';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/pawhere_logo.jpg',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Text(
                'Image not found: assets/images/pawhere_logo.jpg',
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 80),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF134694)),
            ),
          ],
        ),
      ),
    );
  }
}
