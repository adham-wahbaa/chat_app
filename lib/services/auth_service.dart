import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/views/email_verification_screen.dart';
import 'package:chat_app/views/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static Future<void> updateUserVerificationStatus(bool isVerified) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .update({'isVerified': isVerified});
    }
  }

  static Future<bool> checkVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    await currentUser.reload();
    final isEmailVerified = currentUser.emailVerified;

    if (isEmailVerified) {
      await updateUserVerificationStatus(true);
    }

    return isEmailVerified;
  }

  static Future<void> sendResetEmail(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email sent to $email")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An unknown error occurred.")),
      );
    }
  }

  static Future<void> register(
      String email, String password, String userName, BuildContext context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName(userName);

      final user = UserModel(
        email: email,
        id: credential.user!.uid,
        username: userName,
        isVerified: false,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set(user.toJson());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An unknown error occurred.")),
      );
    }
  }

  static Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user!.emailVerified) {
        await updateUserVerificationStatus(true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please verify your email to continue.")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmailVerificationScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An unknown error occurred.")),
      );
    }
  }
}
