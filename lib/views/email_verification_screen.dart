import 'dart:async';

import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with SingleTickerProviderStateMixin {
  late final Timer timer;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceIn),
    );
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _animationController.repeat(reverse: true);

    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final isUserVerified = await AuthService.checkVerificationStatus();
      if (isUserVerified) {
        timer.cancel();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,

                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.brightGreen,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brightGreen.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    size: 70,
                    color: AppColors.background,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Verify Your Email",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "We've sent a verification link to your email address. Please check your inbox and click the link to continue.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) => Transform.scale(
                  scale: _pulseAnimation.value,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.brightGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Waiting for verification...",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                },
                child: Text(
                  "Resend verification email",
                  style: TextStyle(color: AppColors.brightGreen),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
