import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pawhere/features/onboarding/screens/welcome_screen.dart';
import 'package:pawhere/features/onboarding/screens/pairing_screen.dart';
import 'package:pawhere/features/home/screens/main_feature_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Ensure a signed-in user so we can get an ID token for proxy calls.
  final auth = FirebaseAuth.instance;
  if (auth.currentUser == null) {
    await auth.signInAnonymously();
  }
  runApp(const PawhereApp());
}

class PawhereApp extends StatelessWidget {
  const PawhereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawHere',
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.routeName,
      routes: {
        WelcomeScreen.routeName: (_) => const WelcomeScreen(),
        PairingScreen.routeName: (_) => const PairingScreen(),
        MainFeatureShell.routeName: (_) => const MainFeatureShell(),
      },
    );
  }
}
