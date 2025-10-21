import 'package:flutter/material.dart';
// FIX: Corrected import path (assuming pawhere is the package name)
import 'package:pawhere/features/home/screens/main_feature_shell.dart'; 

/// Screen where a new user enters device details or skips to the main app (Experience).
class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  // New UI uses two fields
  final TextEditingController _accImeiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isPairing = false;

  /// Simulates device pairing and navigates to the main map.
  void _pairDeviceAndStartTracking() async {
    final imei = _accImeiController.text.trim();
    final password = _passwordController.text.trim();
    
    if (imei.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both Device/Account ID and Password.')),
      );
      return;
    }

    setState(() {
      _isPairing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      _navigateToMainFeatureShell();
    }
  }

  /// Handles navigation for both successful pairing/login AND the 'Experience' button.
  void _navigateToMainFeatureShell() {
      // Navigate to the MainFeatureShell, replacing the entire navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MainFeatureShell(),
        ),
        (Route<dynamic> route) => false, 
      );
  }


  @override
  void dispose() {
    _accImeiController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // The Logo (Small P icon)
            Center(
              // FIX: This needs to be a smaller crop/icon version of the logo, 
              // but we will use the full logo asset path for now for the demo
              child: Image.asset(
                'assets/images/pawhere_logo.jpg', 
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pair Your Device Now',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 40),

            // Text Field 1: ACC/IMEI
            TextField(
              controller: _accImeiController,
              decoration: InputDecoration(
                hintText: 'Please enter acc/15 digit imei',
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50), 
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),

            // Text Field 2: Password
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Please enter your password',
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50), 
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 30),

            // Button 1: Pair Device & Start Tracking (Dark Blue)
            ElevatedButton(
              onPressed: _isPairing ? null : _pairDeviceAndStartTracking,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF134694),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), 
              ),
              child: _isPairing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Pair Device & start Tracking',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 16),
            
            // Button 2: Create Account (Orange/Yellow)
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigating to Create Account screen (AuthHub)')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4A905), 
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
                elevation: 0,
              ),
              child: const Text(
                'Create account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Experience Link (TextButton) - Direct route to Main App
            Center(
              child: TextButton(
                onPressed: _navigateToMainFeatureShell, 
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'Don\'t have Account yet? just wanna ',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'experience',
                        style: TextStyle(
                          color: Color(0xFF134694), 
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}