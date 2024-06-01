import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_app/config/constants.dart';
import 'package:intl/intl.dart';

import '../../../components/my_submission_card.dart';
import '../../../models/submission_model.dart';
import '../../../repositories/submission_repository.dart';
import '../add_submission_report_page.dart';

class SubmissionMenu extends StatefulWidget {
  final String rid;
  final String role;
  const SubmissionMenu({super.key, required this.rid, required this.role});

  @override
  State<SubmissionMenu> createState() => _SubmissionMenuState();
}

class _SubmissionMenuState extends State<SubmissionMenu> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Submission>>(
        stream: db
            .collection('submission')
            .withConverter(
                fromFirestore: Submission.fromFirestore,
                toFirestore: (Submission submission, options) =>
                    submission.toFirestore())
            .where('rid', isEqualTo: widget.rid)
            .snapshots(),
        builder: (context, snapshot) {
          final querySnaps = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (querySnaps != null && querySnaps.docs.isNotEmpty) {
            final listSubmission = querySnaps.docs;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ListView.builder(
                itemCount: listSubmission.length,
                itemBuilder: (ctx, i) {
                  final submission = listSubmission[i].data();
                  return Dismissible(
                    key: Key(submission.sid),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(
                        Icons.delete_forever,
                        size: 60,
                        color: grey1,
                      ),
                    ),
                    direction: submission.status == 'Terkirim'
                        ? DismissDirection.endToStart
                        : DismissDirection.none,
                    confirmDismiss: (direction) async {
                      if (widget.role == 'Karyawan') {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                              content: Text("Permission denied")));
                        return false;
                      }
                      return await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Hapus Laporan"),
                            content: const Text(
                                "Apakah anda yakin akan menghapus laporan ini?"),
                            actions: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text('Yes'),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) async {
                      SubmissionRepository.deleteSubmission(sid: submission.sid)
                          .then((res) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(res.msg)));
                      });
                    },
                    child: GestureDetector(
                      child: MySubmissionCard(
                        title: submission.title,
                        subtitle: submission.deskripsi,
                        date: DateFormat("EEEE, d MMM y", "id_id").format(submission.createTime),
                        status: '${submission.status}',
                      ),
                      onTap: () {
                        if (widget.role == 'Teknisi') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddSubmissionReportPage(
                                rid: submission.rid,
                                submission: submission,
                              ),
                            ),
                          );
                        } else {
                          showAlertDialog(BuildContext context) {
                            Widget cancelButton = TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            );
                            Widget rejectButton = TextButton(
                              child: const Text(
                                "Tolak",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () async {
                                await SubmissionRepository.updateStatus(
                                        sid: submission.sid, status: 'Ditolak')
                                    .then((res) {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                        SnackBar(content: Text(res.msg)));
                                  Navigator.pop(context, 'Ditolak');
                                });
                              },
                            );
                            Widget approveButton = TextButton(
                              child: const Text("Setuju"),
                              onPressed: () async {
                                await SubmissionRepository.updateStatus(
                                        sid: submission.sid, status: 'Disetujui')
                                    .then((res) {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                        SnackBar(content: Text(res.msg)));
                                  Navigator.pop(context, 'Disetujui');
                                });
                              },
                            );
                            AlertDialog alert = AlertDialog(
                              title: const Text("AlertDialog"),
                              content: const Text(
                                  "Apakah anda akan menyetujui pengajuan ini ?"),
                              actions: [
                                cancelButton,
                                rejectButton,
                                approveButton,
                              ],
                            );
                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          }
                          showAlertDialog(context);
                        }
                      },
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text('Tidak ada pengajuan'),
            );
          }
        });
  }
}
