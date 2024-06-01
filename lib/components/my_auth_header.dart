import 'package:flutter/material.dart';

import '../config/constants.dart';

class MyAuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const MyAuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/ic_launcher.png',
          width: 80,
        ),
        const Divider(
          indent: 140,
          endIndent: 140,
          thickness: 3,
          color: greenPrimary,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}