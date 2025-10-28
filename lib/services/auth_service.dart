import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/views/email_verification_screen.dart';
import 'package:chat_app/views/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {


  static Future<bool> checkVerificationStatus()async{

    FirebaseAuth.instance.currentUser!.reload();
    return FirebaseAuth.instance.currentUser!.emailVerified;

  }

  static Future<void> sendResetEmail(String email, BuildContext context)async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email sent to $email")));

    }catch(e){

    }

  }

  static Future<void> register(String email,String password,String userName,context)async{

    try{

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
         password: password);

      await credential.user!.updateDisplayName(userName);

      final user = UserModel(email: email, id: credential.user!.uid, username: userName);

      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set(
      user.toJson()
      );


    }catch(e)
{    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));


    }

  }

  static Future<void> login(String email, String password,BuildContext context)async{

    try{

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      if(credential.user!.emailVerified){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => HomeScreen(),) , (route) => false);
      }else{
        Navigator.push(context, MaterialPageRoute(builder:(context) => EmailVerificationScreen(),));
      }

    }catch(e){


    }

  }

}