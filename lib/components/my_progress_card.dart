import 'package:flutter/material.dart';

import '../config/constants.dart';

class MyProgressCard extends StatelessWidget {
  final Widget imageUrl;
  final String reportId;
  final String createAt;
  final String title;
  const MyProgressCard({
    super.key, required this.imageUrl, required this.reportId, required this.createAt, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: greenSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl),
        title: Text(reportId),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diterima pada: $createAt'),
            heightS,
            Text(
              'Kerusakan: $title',
              style: const TextStyle(
                color: txtPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        titleTextStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: greenPrimary,
        ),
        subtitleTextStyle: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w400,
          color: grey2,
        ),
      ),
    );
  }
}