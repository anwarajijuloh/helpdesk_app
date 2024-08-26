import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../components/my_progress_card.dart';
import '../../../components/my_timeline_tile.dart';
import '../../../models/report_progress_model.dart';
import '../add_progress_report_page.dart';

class ProgressMenu extends StatefulWidget {
  final String role;
  final String rid;
  final DateTime date;
  final String? image;
  final String title;
  const ProgressMenu(
      {super.key,
      required this.rid,
      required this.role,
      required this.date,
      required this.image,
      required this.title});

  @override
  State<ProgressMenu> createState() => _ProgressMenuState();
}

class _ProgressMenuState extends State<ProgressMenu> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: MyProgressCard(
            imageUrl: widget.image != null
                ? Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Image.asset(
                    'assets/images/service.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
            reportId: '#${widget.rid}',
            createAt:
                DateFormat("EEEE, d MMMM yyyy", "id_ID").format(widget.date),
            title: widget.title,
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<ReportProgress>>(
              stream: db
                  .collection('report_progress')
                  .withConverter(
                      fromFirestore: ReportProgress.fromFirestore,
                      toFirestore: (ReportProgress reportProgress, options) =>
                          reportProgress.toFirestore())
                  .where('rid', isEqualTo: widget.rid)
                  .snapshots(),
              builder: (context, snapshot) {
                final querySnaps = snapshot.data;
                if (querySnaps != null && querySnaps.docs.isNotEmpty) {
                  final listReportProgress = querySnaps.docs;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ListView.builder(
                      itemCount: listReportProgress.length,
                      itemBuilder: (ctx, i) {
                        final reportProgress = listReportProgress[i].data();
                        return GestureDetector(
                          onDoubleTap: () {
                            if (widget.role != 'Teknisi') {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(const SnackBar(
                                    content: Text("Access denied!")));
                            } else {
                              showDialog(
                                context: ctx,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Ubah Laporan"),
                                    content: const Text(
                                        "Apakah anda yakin akan mengubah laporan ini?"),
                                    actions: <Widget>[
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Batal"),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddProgressReportPage(
                                                rid: widget.rid,
                                                reportProgress: reportProgress,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text("Ya"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: MyTimelineTile(
                            title: reportProgress.title,
                            description: reportProgress.deskripsi,
                            estimate: reportProgress.estimasi != null &&
                                    reportProgress.satuanEstimasi != null
                                ? 'Estimasi : ${reportProgress.estimasi} ${reportProgress.satuanEstimasi}'
                                : 'Estimasi : -',
                            dateCreateAt: DateFormat("EEEE, d MMMM", "id_ID")
                                .format(reportProgress.createTime),
                            hourCreateAt: DateFormat("HH.mm", "id_ID")
                                .format(reportProgress.createTime),
                            isLast:
                                i == listReportProgress.length ? true : false,
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text('Belum ada Progress'),
                );
              }),
        ),
      ],
    );
  }
}
