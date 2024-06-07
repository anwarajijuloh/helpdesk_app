import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/my_listile.dart';
import '../../models/report_model.dart';
import 'detail_report_page.dart';

class SearchReportPage extends StatefulWidget {
  final String pid;
  final String role;
  final Report? report;
  const SearchReportPage({
    super.key,
    this.report,
    required this.pid,
    required this.role,
  });

  @override
  State<SearchReportPage> createState() => _SearchReportPageState();
}

class _SearchReportPageState extends State<SearchReportPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  List _allResults = [];
  List _resultList = [];

  final _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(_onSearchChange);
    super.initState();
  }

  _onSearchChange() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var reportSnapshot in _allResults) {
        var title = reportSnapshot['title'].toString().toLowerCase();
        var rid = reportSnapshot['rid'].toString().toLowerCase();
        if (title.contains(_searchController.text.toLowerCase()) ||
            rid.contains(_searchController.text.toLowerCase())) {
          showResults.add(reportSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  getReportStream() async {
    var data = await db
        .collection('report')
        .orderBy('status')
        .orderBy('create_time', descending: true)
        .where('pid', isEqualTo: widget.pid)
        .get();
    if (widget.role == 'Teknisi') {
      data = await db
          .collection('report')
          .orderBy('status')
          .orderBy('create_time', descending: true)
          .get();
    }

    setState(() {
      _allResults = data.docs;
    });

    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChange);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getReportStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.transparent,
            hintText: 'Cari ID atau judul',
            suffixIcon: IconButton(
              onPressed: () {
                _searchController.clear();
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView.builder(
          itemCount: _resultList.length,
          itemBuilder: (context, index) {
            return MyListTile(
              report: Report(
                rid: _resultList[index]['rid'],
                title: _resultList[index]['title'],
                jenis: _resultList[index]['jenis'],
                image: _resultList[index]['image'],
                deskripsi: _resultList[index]['deskripsi'],
                catatan: _resultList[index]['catatan'],
                pid: _resultList[index]['pid'],
                createTime: _resultList[index]['create_time'].toDate(),
                status: _resultList[index]['status'],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailReportPage(
                      report: Report(
                        rid: _resultList[index]['rid'],
                        title: _resultList[index]['title'],
                        jenis: _resultList[index]['jenis'],
                        image: _resultList[index]['image'],
                        deskripsi: _resultList[index]['deskripsi'],
                        catatan: _resultList[index]['catatan'],
                        pid: _resultList[index]['pid'],
                        createTime: _resultList[index]['create_time'].toDate(),
                        status: _resultList[index]['status'],
                      ),
                      role: widget.role,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
