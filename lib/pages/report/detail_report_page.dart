import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk_app/models/person_model.dart';
import 'package:helpdesk_app/pages/report/add_progress_report_page.dart';
import 'package:helpdesk_app/pages/report/add_submission_report_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';
import '../../models/report_model.dart';
import 'menu_detail_report/overview_menu.dart';
import 'menu_detail_report/progress_menu.dart';
import 'menu_detail_report/submission_menu.dart';

class DetailReportPage extends StatefulWidget {
  final Report report;
  const DetailReportPage({super.key, required this.report});

  @override
  State<DetailReportPage> createState() => _DetailReportPageState();
}

class _DetailReportPageState extends State<DetailReportPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var _role;

  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final myrole = prefs.getString('role');
    setState(() {
      _role = myrole;
    });
  }

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
    getSharedPrefs();
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
                    rid: widget.report.rid,
                    dateCreate: widget.report.createTime,
                    title: widget.report.title,
                    jenis: widget.report.jenis,
                    deskripsi: widget.report.deskripsi,
                    status: widget.report.status,
                    catatan: '${widget.report.catatan}',
                    role: '$_role',
                    img: widget.report.image != null
                        ? Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(widget.report.image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Image.asset(
                            'assets/images/service.png',
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  );
                }
                return Container();
              }),
          ProgressMenu(
            rid: widget.report.rid,
            role: _role.toString(),
            date: widget.report.createTime,
            image: widget.report.image,
            title: widget.report.title,
          ),
          SubmissionMenu(
            rid: widget.report.rid,
            role: _role.toString(),
          ),
        ],
      ),
      floatingActionButton: _role == 'Teknisi'
          ? _buildFloatingActionButton(context)
          : const SizedBox(),
    );
  }

  Widget _buildFloatingActionButton(BuildContext ctx) {
    if (_activeIndex == 1) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (context) => AddProgressReportPage(
                rid: widget.report.rid,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      );
    } else if (_activeIndex == 2) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(ctx).push(
            MaterialPageRoute(
              builder: (context) => AddSubmissionReportPage(
                rid: widget.report.rid,
              ),
            ),
          );
        },
        child: const Icon(Icons.create),
      );
    } else {
      return Container();
    }
  }
}
