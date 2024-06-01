import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_app/models/person_model.dart';
import 'package:helpdesk_app/pages/report/add_progress_report_page.dart';
import 'package:helpdesk_app/pages/report/add_submission_report_page.dart';

import '../../config/constants.dart';
import '../../models/report_model.dart';
import 'menu_detail_report/overview_menu.dart';
import 'menu_detail_report/progress_menu.dart';
import 'menu_detail_report/submission_menu.dart';

class DetailReportPage extends StatefulWidget {
  final String role;
  final Report report;
  const DetailReportPage({super.key, required this.report, required this.role});

  @override
  State<DetailReportPage> createState() => _DetailReportPageState();
}

class _DetailReportPageState extends State<DetailReportPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  late TabController _tabController;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() {
      setState(() {
        _activeIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Detail'),
            Tab(text: 'Progress'),
            Tab(text: 'Ajuan'),
          ],
        ),
        title: const Text(
          'Informasi Laporan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: greenPrimary,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StreamBuilder<DocumentSnapshot<Person>>(
              stream: db
                  .collection('person')
                  .withConverter(
                      fromFirestore: Person.fromFirestore,
                      toFirestore: (Person person, options) =>
                          person.toFirestore())
                  .doc(widget.report.pid)
                  .snapshots(),
              builder: (context, snapshot) {
                var personRef = snapshot.data;
                if (personRef != null && personRef.data() != null) {
                  var person = personRef.data()!;
                  return OverviewMenu(
                    name: person.nama,
                    bagian: '${person.bagian}',
                    role: widget.role,
                    report: widget.report,
                  );
                }
                return Container();
              }),
          ProgressMenu(
            rid: widget.report.rid,
            role: widget.role,
            date: widget.report.createTime,
            image: widget.report.image,
            title: widget.report.title,
          ),
          SubmissionMenu(
            rid: widget.report.rid,
            role: widget.role,
          ),
        ],
      ),
      floatingActionButton: widget.role == 'Teknisi'
          ? _buildFloatingActionButton(context)
          : const SizedBox(),
    );
  }

  Widget _buildFloatingActionButton(BuildContext ctx) {
    if (_activeIndex == 1) {
      return FloatingActionButton(
        onPressed: () {
          if (widget.report.status != 'Progress') {
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text(
                  'Laporan tidak dalam progress!',
                ),
              ),
            );
          } else {
            Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (context) => AddProgressReportPage(
                  rid: widget.report.rid,
                ),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      );
    } else if (_activeIndex == 2) {
      return FloatingActionButton(
        onPressed: () {
          if (widget.report.status != 'Progress') {
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(
                content: Text(
                  'Laporan tidak dalam progress!',
                ),
              ),
            );
          } else {
            Navigator.of(ctx).push(
              MaterialPageRoute(
                builder: (context) => AddSubmissionReportPage(
                  rid: widget.report.rid,
                ),
              ),
            );
          }
        },
        child: const Icon(Icons.create),
      );
    } else {
      return Container();
    }
  }
}
