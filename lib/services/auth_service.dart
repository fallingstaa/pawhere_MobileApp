import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:pawhere/firebase_options.dart';
// Add this import for debugPrint
import 'package:flutter/foundation.dart' show debugPrint;

class AuthService {
  // Use a singleton pattern to ensure only one instance of the service exists
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Access FirebaseAuth lazily (after Firebase.initializeApp)
  FirebaseAuth get _auth => FirebaseAuth.instance;

  // Stream to listen to authentication changes. Useful for knowing if the user is logged in.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Helper to get the current user ID for accessing private Firestore data
  String? getCurrentUserId() => _auth.currentUser?.uid;

  /// 1. Initializes Firebase and performs secure sign-in.
  /// This must be called only once at the application start (`main.dart`).
  Future<void> initializeAndSignIn() async {
    const initialAuthToken =
        String.fromEnvironment('initial_auth_token', defaultValue: '');
    const firebaseConfigJson =
        String.fromEnvironment('firebase_config', defaultValue: '');

    FirebaseOptions? options;
    if (firebaseConfigJson.isNotEmpty) {
      try {
        final m = json.decode(firebaseConfigJson) as Map<String, dynamic>;
        options = FirebaseOptions(
          apiKey: m['apiKey'] ?? '',
          appId: m['appId'] ?? '',
          messagingSenderId: m['messagingSenderId'] ?? '',
          projectId: m['projectId'] ?? '',
          authDomain: m['authDomain'],
          storageBucket: m['storageBucket'],
          measurementId: m['measurementId'],
        );
      } catch (e) {
        debugPrint('Failed to parse firebase_config: $e');
      }
    }

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: options ?? DefaultFirebaseOptions.currentPlatform,
      );
    }

    // Try to sign in, but don’t crash if provider isn’t enabled yet
    try {
      if (initialAuthToken.isNotEmpty) {
        await _auth.signInWithCustomToken(initialAuthToken);
      } else {
        await _auth.signInAnonymously(); // requires Anonymous provider enabled
      }
    } on FirebaseAuthException catch (e) {
      // configuration-not-found or operation-not-allowed -> provider not enabled
      debugPrint('Auth sign-in skipped: ${e.code} ${e.message}');
      // App will still run; UI can prompt to enable provider or use email/password.
    }
  }

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();
}
