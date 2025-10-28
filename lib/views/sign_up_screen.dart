import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/views/email_verification_screen.dart';
import 'package:chat_app/views/sign_in_screen.dart';
import 'package:chat_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _userNameController ;

  late TextEditingController _emailController ;

  late TextEditingController _passwordController ;

  late TextEditingController _confirmPasswordController ;
  late AnimationController  _animationController;
  Animation<double>? _animation;

  final  GlobalKey<FormState> formKey = GlobalKey<FormState>();
@override
  void initState() {
_userNameController = TextEditingController();
_emailController = TextEditingController();
_passwordController = TextEditingController();
_confirmPasswordController = TextEditingController();
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
_userNameController.dispose();
_emailController.dispose();
_passwordController.dispose();
_confirmPasswordController.dispose();
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
                const SizedBox(height: 50),
                // WhatsApp-inspired logo/icon area
                ScaleTransition(
                  scale: _animation!,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.brightGreen,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brightGreen.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_add_rounded,
                      size: 50,
                      color: AppColors.background,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Welcome text
                const Text(
                  'Join Our Community!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your account to start chatting with friends',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // Form container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.chatBubbleBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                  key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: 'Enter your username',
                          labelText: 'Username',
                          controller: _userNameController,
                          prefixIcon: Icons.person_outline,
                         validator: (p0) {
                           if(p0!.length < 5){
                            return "Username can\'t be less than 5 characters";
                           }
                           return null;
                         },
                        ),

                        const SizedBox(height: 20),

                        CustomTextField(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                         validator:(p0) {
                           if(!p0!.contains("@")){
                            return "Invalid email";
                           }
                           return null;
                         },
                        ),

                        const SizedBox(height: 20),

                        CustomTextField(
                          hintText: 'Enter your password',
                          labelText: 'Password',
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        CustomTextField(
                          hintText: 'Confirm your password',
                          labelText: 'Confirm Password',
                          controller: _confirmPasswordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        // Sign up button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,

                              colors: [
                              AppColors.brightGreen,
                              AppColors.endGradient
                            ]),
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
                              if(formKey.currentState!.validate()){
                                await AuthService.register(
                                  _emailController.text,
                                   _passwordController.text,
                                    _userNameController.text,context
                                  );

                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) => EmailVerificationScreen(),), (route) => false,);

                              };
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Create Account',
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
                ),

                const SizedBox(height: 30),

                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
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
                            builder: (context) => SignInScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Sign In',
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
