import 'package:flutter/material.dart';
import 'package:helpdesk_app/config/utils/month.dart';

import '../config/constants.dart';
import '../models/report_model.dart';
import 'badge_status.dart';

class MyListTile extends StatelessWidget {
  final Report? report;
  final Function()? onTap;
  final void Function()? onLongPress;
  const MyListTile({
    super.key,
    required this.onTap,
    this.report, this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onLongPress: onLongPress,
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: report!.image == null
              ? Image.asset(
                  'assets/images/service.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(report!.image!), fit: BoxFit.cover),
                  ),
                ),
        ),
        title: Text(
          report!.title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: txtPrimary,
          ),
        ),
        subtitle: Text(
          '#${report!.rid}',
          style: const TextStyle(fontSize: 10),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${report!.createTime.day} ${MyMonth.getMonth(report!.createTime.month)}',
              style: const TextStyle(fontSize: 8),
            ),
            MyBadgeStatus(report!.status, status: report!.status),
          ],
        ),
      ),
    );
  }
}
