import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "login_screen.dart";
import "main_navigation_screen.dart";

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF020617),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF60A5FA),
              ),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const MainNavigationScreen();
        }

        return LoginScreen();
      },
    );
  }
}