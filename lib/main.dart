import 'package:flutter/material.dart';
// FIX 1: Uncommented and corrected package name
import 'package:pawhere/features/home/screens/main_feature_shell.dart';
import 'package:pawhere/features/onboarding/screens/welcome_screen.dart';
import 'package:pawhere/features/onboarding/screens/pairing_screen.dart';

// Helper function to simulate checking local storage for a paired device ID.
Future<bool> _checkPairingStatus() async {
  // --- SIMULATION ---
  await Future.delayed(const Duration(milliseconds: 50));
  
  // Remains 'false' to force the Quick Pair screen for initial testing
  return false; 
}

void main() {
  runApp(const PawhereApp());
}

class PawhereApp extends StatelessWidget {
  const PawhereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawhere Pet Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // FIX 2: visualDensity.adaptivePlatformDensity is deprecated/removed.
        // It is safest to remove it completely in modern Flutter versions.
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      // Start the app with the Welcome screen (splash screen)
      initialRoute: WelcomeScreen.routeName, 
      routes: {
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        
        // The root route ('/') is where the core logic lives for the NEW FLOW.
        '/': (context) => FutureBuilder<bool>(
              future: _checkPairingStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                }
                
                final isPaired = snapshot.data ?? false;

                if (isPaired) {
                  // NEW FLOW SUCCESS: Go straight to the main map
                  return const MainFeatureShell();
                } else {
                  // NEW FLOW INITIAL: No pairing found, force the Quick Pair screen
                  return const PairingScreen();
                }
              },
            ),
      },
    );
  }
}