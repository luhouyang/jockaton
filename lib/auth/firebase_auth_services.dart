import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthServices {
  Future<void> signUp(
      BuildContext context, String email, String password) async {
    try {
      debugPrint("SIGNING UP");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle authentication exceptions
      debugPrint("Error during create user: $e");

      // You can customize this part based on your requirements
      if (e is FirebaseAuthException) {
        // Show a pop-up modal for incorrect email or password
        // ignore: use_build_context_synchronously
        _showErrorDialog(context, "Error $e");
      }
    }
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      debugPrint("SIGNING IN");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle authentication exceptions
      debugPrint("Error during sign-in: $e");

      // You can customize this part based on your requirements
      if (e is FirebaseAuthException) {
        // Show a pop-up modal for incorrect email or password
        // ignore: use_build_context_synchronously
        _showErrorDialog(context, "Error $e");
      }
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Handle exceptions
      debugPrint("Error during send reset email: $e");

      // You can customize this part based on your requirements
      if (e is FirebaseAuthException) {
        // Show a pop-up modal for incorrect email or password
        // ignore: use_build_context_synchronously
        _showErrorDialog(context, "Error $e");
      }
    }
  }

  // Function to show an error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Authentication Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
