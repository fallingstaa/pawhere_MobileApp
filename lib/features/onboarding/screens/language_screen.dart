import 'package:flutter/material.dart';
import 'package:pawhere/features/onboarding/widgets/language_button.dart';
import 'package:pawhere/features/auth/screens/auth_hub_screen.dart'; // This is the new import

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Center(
              child: Image.asset(
                'assets/images/pawhere_logo.jpg',
                height: 100,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Choose your language',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // English language button
            LanguageButton(
              language: 'English',
              flagPath: 'assets/images/uk.png',
              isSelected: _selectedLanguage == 'English',
              onTap: () {
                setState(() {
                  _selectedLanguage = 'English';
                });
              },
            ),
            const SizedBox(height: 16),
            // Khmer language button
            LanguageButton(
              language: 'ភាសាខ្មែរ',
              flagPath: 'assets/images/kh.png',
              isSelected: _selectedLanguage == 'ភាសាខ្មែរ',
              onTap: () {
                setState(() {
                  _selectedLanguage = 'ភាសាខ្មែរ';
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // This will now navigate to the new screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthHubScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF134694),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Confirm', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
