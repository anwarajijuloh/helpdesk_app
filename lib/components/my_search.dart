import 'package:flutter/material.dart';

import '../config/constants.dart';

class MySearch extends StatelessWidget {
  final Function()? onTap;
  const MySearch({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
        decoration: BoxDecoration(
          color: grey1,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cari laporan..',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: grey2,
              ),
            ),
            Icon(
              Icons.search_rounded,
              color: grey3,
            ),
          ],
        ),
      ),
    );
  }
}