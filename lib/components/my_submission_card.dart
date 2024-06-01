import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../config/utils/status.dart';

class MySubmissionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final String date;
  const MySubmissionCard({
    super.key, required this.title, required this.subtitle, required this.status, required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: greenSecondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: greenPrimary,),),
          heightS,
          Text(subtitle, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: txtPrimary,),),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4,),
                decoration: BoxDecoration(
                  color: MyStatus.getColorSub(status),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(status, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Colors.white,),),
              ),
              Text(date, textAlign: TextAlign.end, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: grey2,),),
            ],
          ),
        ],
      ),
    );
  }
}