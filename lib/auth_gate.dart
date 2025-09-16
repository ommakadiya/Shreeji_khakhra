import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot is still loading, show a progress indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the user is logged in, show the home screen
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // Otherwise, the user is logged out, show the login screen
        return const LoginOrSignUpScreen();
      },
    );
  }
}
