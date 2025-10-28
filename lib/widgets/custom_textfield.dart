import 'package:chat_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color:AppColors.brightGreen , width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
      ),
    );
  }
}