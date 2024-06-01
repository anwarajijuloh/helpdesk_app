import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_app/pages/report/add_report_page.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../components/my_elevated_button.dart';
import '../../../components/my_overview_report_card.dart';
import '../../../components/my_sender_card.dart';
import '../../../config/constants.dart';
import '../../../models/report_model.dart';
import '../../../repositories/report_repository.dart';

// ignore: must_be_immutable
class OverviewMenu extends StatefulWidget {
  final String name;
  final String bagian;
  final String role;
  final Report? report;
  const OverviewMenu({
    super.key,
    required this.name,
    required this.bagian,
    required this.role,
    this.report,
  });

  @override
  State<OverviewMenu> createState() => _OverviewMenuState();
}

class _OverviewMenuState extends State<OverviewMenu> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MySenderCard(
              name: widget.name,
              departement: widget.bagian,
            ),
            heightM,
            MyOverviewReportCard(
              reportId: '#${widget.report!.rid}',
              createAt:
                  DateFormat("EEEE, d MMM y\nHH.mm", "id_id").format(widget.report!.createTime),
              imageAssets: widget.report!.image != null
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.report!.image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.report!.image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Image.asset(
                      'assets/images/service.png',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              title: widget.report!.title,
              category: widget.report!.jenis,
              description: widget.report!.deskripsi,
              status: widget.report!.status,
              note: widget.report!.catatan!,
            ),
            heightL,
            widget.role == 'Teknisi'
                ? MyElevatedButton(
                    title: widget.report!.status == 'Progress'
                        ? 'Selesai'
                        : (widget.report!.status == 'Selesai')
                            ? 'Reprogress'
                            : 'Progress',
                    onPressed: () async {
                      var newStatus = widget.report!.status == 'Progress'
                          ? 'Selesai'
                          : 'Progress';
                      await db
                          .collection('report')
                          .where('status', whereIn: ['Progress', 'Diterima'])
                          .where('create_time',
                              isLessThan: widget.report!.createTime)
                          // .count()
                          .get()
                          .then((res) {
                            ReportRepository.updateStatus(
                                    status: newStatus, rid: widget.report!.rid)
                                .then((res) {
                              setState(() {
                                widget.report!.status = newStatus;
                              });
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(SnackBar(content: Text(res.msg)));
                            });
                          });
                    },
                  )
                : (widget.report!.status != 'Diterima')
                    ? const SizedBox()
                    : MyElevatedButton(
                        title: 'Edit Laporan',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddReportPage(report: widget.report)));
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
