import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawhere/features/auth/screens/reset_password_screen.dart'; // Corrected spelling from 'resert' to 'reset'
import 'package:pawhere/features/auth/screens/register_screen.dart'; // Import for the Register screen
import 'package:pawhere/features/home/screens/home_screen.dart'; // Import for the main page

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();
  String _passwordErrorText = '';
  bool _rememberMe = false; // Add a state variable for the checkbox
  
  // A simple password validation function
  void _validatePassword(String password) {
    // Regex for at least 8 characters, one uppercase, one lowercase, one number, one symbol
    final passwordRegex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`_+-=\|(){}[\]:;<>,.?/]).{8,}$');
    
    if (password.isEmpty) {
      setState(() {
        _passwordErrorText = 'Password cannot be empty.';
      });
    } else if (!passwordRegex.hasMatch(password)) {
      setState(() {
        _passwordErrorText = 'Password must be at least 8 characters and contain at least one uppercase letter, one lowercase letter, one number, and one symbol.';
      });
    } else {
      setState(() {
        _passwordErrorText = '';
      });
    }
  }

  @override
  void dispose() {
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pawhere logo
              RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Paw',
                        style: TextStyle(color: Color(0xFF0F459A)),
                      ),
                      TextSpan(
                        text: 'here',
                        style: TextStyle(color: Color(0xFFF4A905)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              // "Login" title
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Email input field
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password input field
              TextField(
                controller: _passwordController,
                onChanged: _validatePassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  errorText: _passwordErrorText.isNotEmpty ? _passwordErrorText : null,
                ),
              ),
              const SizedBox(height: 16),
              // "Remember me" and "Forgot password?"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe, // Use the state variable
                        onChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              _rememberMe = value; // Update the state
                            });
                          }
                        },
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()), // Corrected class name
                      );
                    },
                    child: const Text('Forgot password?'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Login button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                      // Navigate to home screen without validation
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF134694),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('OR'),
              const SizedBox(height: 24),
              // Continue with Google button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement Google sign-in
                  },
                  icon: Image.asset('assets/images/goggle.png', height: 24),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Continue with Facebook button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement Facebook sign-in
                  },
                  icon: Image.asset('assets/images/fb.jpg', height: 24),
                  label: const Text('Continue with Facebook'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // "Don't have an account?" text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigate to Register Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
