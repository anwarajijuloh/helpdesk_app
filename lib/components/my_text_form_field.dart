import 'package:flutter/material.dart';

import '../config/constants.dart';

// ignore: must_be_immutable
class MyTextFormField extends StatefulWidget {
  final String hintText;
  final IconData icons;
  bool isObscured;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  MyTextFormField({
    super.key,
    required this.hintText,
    required this.icons,
    required this.isObscured,
    this.validator,
    this.controller,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isObscured,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Icon(
            widget.icons,
            size: 28,
            color: greenPrimary,
          ),
        ),
        contentPadding: const EdgeInsets.all(14.0),
        suffixIcon: widget.icons == Icons.lock
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.isObscured =!widget.isObscured;
                  });
                },
                icon: Icon(
                  widget.isObscured
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
              )
            : null,
      ),
    );
  }
}