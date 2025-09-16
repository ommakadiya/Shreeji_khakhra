import 'package:flutter/material.dart';
import 'package:shreejikhakhra/login_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // FIXED: Correct asset path
              Image.asset(
                'lib/assets/images/logo.png',
                height: 150,
              ),
              const SizedBox(height: 48.0),
              const Text(
                'Welcome to Shreeji Khakhra',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                'Login or create an account to explore our delicious snacks.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
              const SizedBox(height: 48.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginOrSignUpScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF97700),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('Login',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginOrSignUpScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F5F5),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 0,
                ),
                child: const Text('Create an Account',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // TODO: Add guest navigation logic
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: const Text('Continue as Guest',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
