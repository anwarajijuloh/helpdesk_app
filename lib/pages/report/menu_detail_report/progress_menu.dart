import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../components/my_progress_card.dart';
import '../../../components/my_timeline_tile.dart';
import '../../../models/report_progress_model.dart';
import '../../../repositories/report_progress_repository.dart';
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
                              if (i + 1 == listReportProgress.length) {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                      content: Text("Progress telah selesai")));
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
                                                  reportProgress:
                                                      reportProgress,
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
                            }
                          },
                          onLongPress: () {
                            // Map QueryDocumentSnapshot to ReportProgress objects
                            List<ReportProgress> reportProgressList =
                                listReportProgress
                                    .map((doc) => ReportProgress.fromFirestore(
                                        doc as DocumentSnapshot<
                                            Map<String, dynamic>>,
                                        null))
                                    .toList();

                            // Sort the list by createTime if not already sorted
                            reportProgressList.sort(
                                (a, b) => b.createTime.compareTo(a.createTime));
                            // Check if reportProgress.createTime is not the most recent one
                            if (reportProgressList.isNotEmpty &&
                                reportProgress.createTime !=
                                    reportProgressList.first.createTime) {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(const SnackBar(
                                    content: Text("Progress telah selesai")));
                            } else {
                              // If there is only one reportProgress or the user role is not 'Karyawan'
                              if (reportProgressList.length == 1 ||
                                  widget.role != 'Karyawan') {
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
                                        title: const Text("Hapus Laporan"),
                                        content: const Text(
                                            "Apakah anda yakin akan menghapus laporan ini?"),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () {
                                              ReportProgressRepository
                                                      .deleteReportProgress(
                                                          rpid: reportProgress
                                                              .rpid)
                                                  .then((res) {
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(SnackBar(
                                                      content: Text(res.msg)));
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                      content: Text("Permission denied")));
                              }
                            }
                            // if (widget.role == 'Karyawan') {
                            //   ScaffoldMessenger.of(context)
                            //     ..removeCurrentSnackBar()
                            //     ..showSnackBar(const SnackBar(
                            //         content: Text("Permission denied")));
                            // }
                            // if (i + 1 == listReportProgress.length) {
                            //   ScaffoldMessenger.of(context)
                            //     ..removeCurrentSnackBar()
                            //     ..showSnackBar(const SnackBar(
                            //         content: Text("Progress telah selesai")));
                            // } else {
                            //   if (widget.role != 'Teknisi') {
                            //     ScaffoldMessenger.of(context)
                            //       ..removeCurrentSnackBar()
                            //       ..showSnackBar(const SnackBar(
                            //           content: Text("Access denied!")));
                            //   } else {
                            //     showDialog(
                            //       context: ctx,
                            //       builder: (context) {
                            //         return AlertDialog(
                            //           title: const Text("Hapus Laporan"),
                            //           content: const Text(
                            //               "Apakah anda yakin akan menghapus laporan ini?"),
                            //           actions: <Widget>[
                            //             MaterialButton(
                            //               onPressed: () {
                            //                 ReportProgressRepository
                            //                         .deleteReportProgress(
                            //                             rpid:
                            //                                 reportProgress.rpid)
                            //                     .then((res) {
                            //                   ScaffoldMessenger.of(context)
                            //                     ..removeCurrentSnackBar()
                            //                     ..showSnackBar(SnackBar(
                            //                         content: Text(res.msg)));
                            //                 });
                            //                 Navigator.pop(context);
                            //               },
                            //               child: const Text('Yes'),
                            //             ),
                            //             MaterialButton(
                            //               onPressed: () {
                            //                 Navigator.pop(context);
                            //               },
                            //               child: const Text('No'),
                            //             ),
                            //           ],
                            //         );
                            //       },
                            //     );
                            //   }
                            // }
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
