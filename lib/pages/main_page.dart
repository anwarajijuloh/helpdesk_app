import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../components/my_appbar.dart';
import '../models/report_model.dart';
import '../repositories/auth_repository.dart';
import '../components/my_listile.dart';
import '../components/my_search.dart';
import '../config/constants.dart';
import '../repositories/report_repository.dart';
import 'report/detail_report_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var pid;
  var role;
  var nama;

  List<String> filterList = [
    'Semua',
    'Diterima',
    'Progress',
    'Selesai',
  ];

  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final mypid = prefs.getString('pid');
    final myrole = prefs.getString('role');
    final myname = prefs.getString('username');

    setState(() {
      pid = mypid;
      role = myrole;
      nama = myname;
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  var selected = 'Semua';
  @override
  Widget build(BuildContext context) {
    var query = db
        .collection('report')
        .withConverter(
            fromFirestore: Report.fromFirestore,
            toFirestore: (Report report, options) => report.toFirestore())
        .where('pid', isEqualTo: pid);
    if (selected != 'Semua') {
      query = query.where('status', isEqualTo: selected);
    }
    if (role == 'Teknisi') {
      query = db.collection('report').withConverter(
          fromFirestore: Report.fromFirestore,
          toFirestore: (
            Report report,
            options,
          ) =>
              report.toFirestore());
      if (selected != 'Semua') {
        query = query.where('status', isEqualTo: selected);
      }
    }
    return Scaffold(
      appBar: myAppBar(context, '$nama', () async {
        await AuthRepository.authSignout().then(
          (res) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(res.msg)));
            if (res.success) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/signin_page', (route) => false);
            }
          },
        );
      }),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            MySearch(
              onTap: () {
                Navigator.of(context).pushNamed('/search_report');
              },
            ),
            heightM,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Report',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: txtPrimary,
                  ),
                ),
                PopupMenuButton(
                  onSelected: (value) {
                    setState(() {
                      selected = value.toString();
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: grey2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selected,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: grey2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.filter_list_rounded,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context) {
                    return filterList.map((x) {
                      return PopupMenuItem(
                        value: x,
                        child: Text(x),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            heightM,
            Expanded(
              child: StreamBuilder<QuerySnapshot<Report>>(
                stream:
                    query.orderBy('create_time', descending: false).snapshots(),
                builder: (context, snapshot) {
                  final querySnap = snapshot.data;
                  if (querySnap != null && querySnap.docs.isNotEmpty) {
                    final listReport = querySnap.docs;
                    return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (ctx, i) {
                          final report = listReport[i].data();
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            key: Key(report.rid),
                            background: Container(
                              color: const Color.fromARGB(255, 167, 37, 27),
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (role != 'Karyawan') {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                      content: Text('Permission Denied')));
                                return false;
                              }
                              if (report.status != 'Diterima') {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                      content: Text(
                                          'Laporan sedang dalam progress')));
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
                              await ReportRepository.deleteReport(rid: report.rid)
                                  .then((res) {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                      SnackBar(content: Text(res.msg)));
                              });
                            },
                            child: MyListTile(
                              report: report,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailReportPage(report: report),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        separatorBuilder: (ctx, i) {
                          return const Divider();
                        },
                        itemCount: listReport.length,
                      ),
                    );
                  }
                  return Center(
                    child: Text('Belum ada laporan\n$selected', textAlign: TextAlign.center,),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: role.toString() == 'Teknisi'
          ? const SizedBox()
          : FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/add_report'),
              child: const Icon(Icons.add),
            ),
    );
  }

  Future<void> _pullRefresh() async {
    await getSharedPrefs();
  }
}
