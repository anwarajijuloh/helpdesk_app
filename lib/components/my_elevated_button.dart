import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  const MyElevatedButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}