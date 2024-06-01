import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../config/constants.dart';

class MyTimelineTile extends StatelessWidget {
  final String dateCreateAt;
  final String hourCreateAt;
  final String title;
  final bool isLast;
  const MyTimelineTile({
    super.key, required this.title, required this.isLast, required this.dateCreateAt, required this.hourCreateAt,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isLast: isLast,
      axis: TimelineAxis.vertical,
      alignment: TimelineAlign.manual,
      afterLineStyle: const LineStyle(color: greenPrimary, thickness: 2,),
      beforeLineStyle: const LineStyle(color: greenPrimary, thickness: 2,),
      indicatorStyle: const IndicatorStyle(
        color: greenPrimary,
        width: 12,
        height: 12,
      ),
      lineXY: 0.26,
      endChild: Container(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minWidth: 120,
        ),
        child: Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: txtPrimary,),),
      ),
      startChild: Container(
        padding: const EdgeInsets.all(8),
        child: Text('$dateCreateAt\n$hourCreateAt', style: const TextStyle(fontSize: 6, fontWeight: FontWeight.w500, color: grey2,), textAlign: TextAlign.end,),
      ),
    );
  }
}