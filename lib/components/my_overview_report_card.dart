import 'package:flutter/material.dart';
import 'package:helpdesk_app/config/utils/status.dart';

import '../config/constants.dart';

class MyOverviewReportCard extends StatelessWidget {
  final String reportId;
  final String createAt;
  final Widget imageAssets;
  final String title;
  final String category;
  final String description;
  final String note;
  final String status;
  const MyOverviewReportCard({
    super.key,
    required this.reportId,
    required this.createAt,
    required this.imageAssets,
    required this.title,
    required this.category,
    required this.description,
    required this.note,
    required this.status
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: greenSecondary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reportId,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: greenPrimary,
                    ),
                  ),
                  Text(
                    createAt,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: grey3,
                    ),
                  ),
                ],
              ),
              const Divider(),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: imageAssets,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: greenPrimary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              heightM,
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: MyStatus.getColor(status),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          MyStatus.getIcon(status),
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        status,
                        style: const TextStyle(
                          fontSize: 8,
                          color: grey3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(
                  'Jenis: $category',
                ),
                subtitle: Text(
                    '"$description"'),
                titleTextStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: grey2,
                  fontStyle: FontStyle.italic,
                ),
                subtitleTextStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: grey3,
                    height: 1.5),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: greenPrimary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Text(
            'Catatan : $note',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}