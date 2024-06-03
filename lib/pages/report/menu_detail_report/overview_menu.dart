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
  final _reportCollection = FirebaseFirestore.instance.collection('report');
  Future<void> changeStatusReport(String rid) async {
    final reportDoc = await _reportCollection.doc(rid).get();

    if (!reportDoc.exists) {
      return;
    }

    final report = Report.fromFirestore(reportDoc);

    if (report.status == 'Diterima') {
      final reportOldest = await _getReportReceivedOldes();
      if (reportOldest == null || reportOldest.rid == rid) {
        await _reportCollection.doc(rid).update({
          'status': 'Progress',
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Laporan diproses'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ada laporan lain yang lebih terdahulu'),
        ));
      }
    } else if (report.status == 'Progress') {
      await _reportCollection.doc(rid).update({
        'status': 'Selesai',
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Laporan selesai'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Status laporan tidak valid'),
      ));
    }
  }

  Future<Report?> _getReportReceivedOldes() async {
    final querySnapshot = await _reportCollection
        .where('status', isEqualTo: 'Diterima')
        .orderBy('create_time', descending: false)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return Report.fromFirestore(querySnapshot.docs.first);
    } else {
      return null;
    }
  }

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
              createAt: DateFormat("EEEE, d MMM y\nHH.mm", "id_id")
                  .format(widget.report!.createTime),
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
                        ? 'Laporan Selesai'
                        : (widget.report!.status == 'Selesai')
                            ? 'Progress Kembali'
                            : 'Progress Laporan',
                    onPressed: () async {
                      await changeStatusReport(widget.report!.rid);
                      // var newStatus = widget.report!.status == 'Progress'
                      //     ? 'Selesai'
                      //     : 'Progress';
                      // await db
                      //     .collection('report')
                      //     .where('status', whereIn: ['Progress', 'Diterima'])
                      //     .orderBy('create_time',
                      //         descending: true)
                      //     .limit(1)
                      //     .get()
                      //     .then(
                      //       (res) {
                      //         ReportRepository.updateStatus(
                      //                 status: newStatus,
                      //                 rid: widget.report!.rid)
                      //             .then(
                      //           (res) {
                      //             setState(() {
                      //               widget.report!.status = newStatus;
                      //             });
                      //             ScaffoldMessenger.of(context)
                      //               ..removeCurrentSnackBar()
                      //               ..showSnackBar(
                      //                   SnackBar(content: Text(res.msg)));
                      //           },
                      //         );
                      //       },
                      //     );
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
                                  AddReportPage(report: widget.report),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
