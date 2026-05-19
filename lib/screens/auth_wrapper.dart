import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "login_screen.dart";
import "main_navigation_screen.dart";

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  bool isAllowedUser(User user) {
    final bool isEmailUser =
        user.email != null && user.emailVerified;

    final bool isPhoneUser =
        user.phoneNumber != null && user.phoneNumber!.isNotEmpty;

    return isEmailUser || isPhoneUser;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = snapshot.data;

        if (user != null && isAllowedUser(user)) {
          return const MainNavigationScreen();
        }

        if (user != null && !isAllowedUser(user)) {
          FirebaseAuth.instance.signOut();
        }

        return const LoginScreen();
      },
    );
  }
}