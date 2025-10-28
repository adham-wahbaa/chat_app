import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/action_button.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>with SingleTickerProviderStateMixin {
late AnimationController _animationController;
  final TextEditingController _emailController = TextEditingController();
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;


  @override
initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve:Interval(0.3, 1,curve:  Curves.easeIn)),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Interval(0,0.3, curve:Curves.bounceIn)),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0,0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve:Interval(0.3, 1, curve: Curves.easeOut)),
    );
    super.initState();
    _animationController.forward();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 20),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 15,),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.chatBubbleBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30,),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.brightGreen.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 5,
                          offset: Offset(0, 10)
                        )
                    ],
                    gradient: LinearGradient(
                      colors: [AppColors.brightGreen,AppColors.endGradient],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                      )
                  ),
                  child: Icon(Icons.lock_reset_rounded,color: AppColors.background,size: 70,),
                ),
              ),
              const SizedBox(height: 20,),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text("Reset Password",style: TextStyle(fontSize: 32,fontWeight: FontWeight.w600, color: Colors.white),)),
              const SizedBox(height: 20,),
            Text(
                  "Enter your email address and we will send you a link to reset your password",
                  style: TextStyle(color: Colors.grey.shade400,fontSize: 16,),
                  textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 30,),
              SlideTransition(
                position: _slideAnimation,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  decoration: BoxDecoration(
                    color: AppColors.chatBubbleBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.brightGreen.withOpacity(0.2)
                            ),
                            child: Icon(Icons.mail_outline,color: AppColors.brightGreen,),
                          ),
                          const SizedBox(width: 20,),
                          Text("Recovery Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: Colors.white),)
                        ],
                      ),
                      const SizedBox(height: 20,),
                      CustomTextField(hintText: "Enter your email", labelText: "Email", controller: _emailController),
                      const SizedBox(height: 20,),
                      ActionButton(onPressed: ()async{
                        await AuthService.sendResetEmail(_emailController.text, context);
                      },
                      title: "Send Recovery Email",
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
