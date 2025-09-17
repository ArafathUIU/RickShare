import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'login.dart';
import 'verify_email.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          // No user → Login
          return LoginPage();
        } else if (!user.emailVerified) {
          // User exists but email not verified → show verify page
          return VerifyEmailPage(user: user);
        } else {
          // Email verified → go to homepage
          return HomePage(user: user);
        }
      },
    );
  }
}
