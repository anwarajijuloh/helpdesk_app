import 'package:flutter/material.dart';

import '../config/utils/status.dart';

class MyBadgeStatus extends StatelessWidget {
  final String status;
  const MyBadgeStatus(String statusReport, {
    super.key, required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MyStatus.getColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        MyStatus.getIcon(status),
        size: 12,
        color: Colors.white,
      ),
    );
  }
}