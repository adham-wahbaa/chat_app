import 'dart:async';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  late final Timer timer;


  @override
  void initState() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 3), (_)async{
     final isUserVerified =  await AuthService.checkVerificationStatus();
     if(isUserVerified){
      timer.cancel();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) {
        return HomeScreen();
      },), (route) => false);
     }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined,size: 70,),
            Text("Verify your email"),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}