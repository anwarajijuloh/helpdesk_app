import 'package:flutter/material.dart';

import '../config/constants.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const MyTextField({super.key, required this.labelText, required this.hintText, required this.controller, this.validator, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: greenPrimary,),
        hintText: hintText,
        contentPadding: const EdgeInsets.all(18),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}