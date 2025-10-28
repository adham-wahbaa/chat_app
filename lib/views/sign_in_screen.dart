import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/views/reset_password_screen.dart';
import 'package:chat_app/views/sign_up_screen.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _emailController ;
  late AnimationController  _animationController;
  Animation<double>? _animation;

   late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController ,curve:Curves.easeIn )
      );
  _animationController.forward();
    super.initState();
  }
dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),

                ScaleTransition(
                  scale: _animation!,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.brightGreen,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brightGreen.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.chat_bubble_rounded,
                      size: 60,
                      color: AppColors.background,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Welcome text
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue chatting with your friends',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                // Form container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.chatBubbleBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: 'Enter your email',
                        labelText: 'Email',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        hintText: 'Enter your password',
                        labelText: 'Password',
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                      ),

                      const SizedBox(height: 16),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder:(context) => ResetPasswordScreen(),));
                          },
                          child:  Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.brightGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sign in button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.brightGreen, AppColors.endGradient],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brightGreen.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            await AuthService.login(
                                _emailController.text,
                                _passwordController.text, context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child:  Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.brightGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
