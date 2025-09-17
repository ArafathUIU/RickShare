import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailPage extends StatefulWidget {
  final User user;
  const VerifyEmailPage({required this.user, super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isReloading = false;

  Future<void> _checkVerification() async {
    setState(() => _isReloading = true);

    await widget.user.reload(); // 🔹 Refresh user from Firebase
    final updatedUser = FirebaseAuth.instance.currentUser!;

    if (updatedUser.emailVerified) {
      // ✅ Wrapper listens to authStateChanges, so just setState is not enough
      // Force rebuild by calling setState AND using Navigator.pop()
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verified! Redirecting...')),
      );

      // 🔹 Pop this page → Wrapper will now show HomePage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SizedBox()), // dummy widget
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email not verified yet!')),
      );
    }

    setState(() => _isReloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'A verification email has been sent. Please check your inbox (or spam).',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isReloading ? null : _checkVerification,
              child: _isReloading
                  ? const CircularProgressIndicator()
                  : const Text('Reload'),
            ),
          ],
        ),
      ),
    );
  }
}
