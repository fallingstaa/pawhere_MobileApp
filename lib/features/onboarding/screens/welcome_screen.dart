import 'package:flutter/material.dart';

// Import the MainFeatureShell to use its route, though we will let main.dart decide
import 'package:pawhere/features/home/screens/main_feature_shell.dart'; 

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
    _startTimerAndNavigate();
  }

  void _startTimerAndNavigate() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Navigates to the root route ('/') where main.dart performs the pairing check.
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // REMOVED 'const' from Scaffold to allow non-const Image.asset
    return Scaffold( 
      // Changed background to white to match the design (image_f0d90d.png)
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FIX: Using Image.asset with the correct path: 'pawhere_logo.jpg'
            Image.asset(
              'assets/images/pawhere_logo.jpg', 
              width: 250, 
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            // Tagline from the visual design (image_f0d90d.png)
            const Text(
              "Now it's always Paw Here!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54, 
              ),
            ),
            const SizedBox(height: 80),
            // Keeping the progress indicator for the loading effect
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF134694)),
            ),
          ],
        ),
      ),
    );
  }
}