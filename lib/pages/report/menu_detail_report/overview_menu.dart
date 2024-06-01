import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_app/repositories/report_repository.dart';

import '../../../components/my_elevated_button.dart';
import '../../../components/my_overview_report_card.dart';
import '../../../components/my_sender_card.dart';
import '../../../config/utils/month.dart';

// ignore: must_be_immutable
class OverviewMenu extends StatefulWidget {
  final String name;
  final String bagian;
  final String rid;
  final DateTime dateCreate;
  final Widget img;
  final String title;
  final String jenis;
  final String deskripsi;
  String status;
  final String catatan;
  final String role;
  OverviewMenu(
      {super.key,
      required this.name,
      required this.bagian,
      required this.rid,
      required this.dateCreate,
      required this.img,
      required this.title,
      required this.jenis,
      required this.deskripsi,
      required this.status,
      required this.catatan,
      required this.role});

  @override
  State<OverviewMenu> createState() => _OverviewMenuState();
}

class _OverviewMenuState extends State<OverviewMenu> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MySenderCard(
            name: widget.name,
            departement: widget.bagian,
          ),
          MyOverviewReportCard(
            reportId: '#${widget.rid}',
            createAt:
                '${widget.dateCreate.day} ${MyMonth.getMonth(widget.dateCreate.month)} ${widget.dateCreate.year}',
            imageAssets: widget.img,
            title: widget.title,
            category: widget.jenis,
            description: widget.deskripsi,
            status: widget.status,
            note: widget.catatan,
          ),
          widget.role == 'Teknisi'
              ? MyElevatedButton(
                  title: widget.status == 'Progress'
                      ? 'Selesai'
                      : (widget.status == 'Selesai')
                          ? 'Reprogress'
                          : 'Progress',
                  onPressed: () async {
                    var newStatus =
                        widget.status == 'Progress' ? 'Selesai' : 'Progress';
                    await db
                        .collection('report')
                        .where('status', whereIn: ['Progress', 'Diterima'])
                        .where('create_time', isLessThan: widget.dateCreate)
                        // .count()
                        .get()
                        .then((res) {
                          ReportRepository.updateStatus(
                                  status: newStatus, rid: widget.rid)
                              .then((res) {
                            setState(() {
                              widget.status = newStatus;
                            });
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(SnackBar(content: Text(res.msg)));
                          });
                        });
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
