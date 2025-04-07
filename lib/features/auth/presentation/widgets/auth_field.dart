import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.black), // Input text color
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(204, 255, 255, 255), // 80% opacity

        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black54), // Soft grey hint
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: Colors.purple.shade200), // Subtle border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: Colors.purple.shade500, width: 2), // Highlight on focus
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
