import 'package:flutter/material.dart';

import '../../components/my_listile.dart';
import '../../models/report_model.dart';

class SearchReportPage extends StatefulWidget {
  final Report? report;
  const SearchReportPage({super.key, this.report});

  @override
  State<SearchReportPage> createState() => _SearchReportPageState();
}

class _SearchReportPageState extends State<SearchReportPage> {
  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          autofocus: true,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.transparent,
            hintText: 'Masukkan judul',
            suffixIcon: IconButton(
              onPressed: () {
                searchController.clear();
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return MyListTile(
              onTap: () {},
              report: Report(
                rid: 'rid',
                title: 'title',
                jenis: 'jenis',
                deskripsi: 'deskripsi',
                catatan: 'catatan',
                pid: 'pid',
                createTime: DateTime.now(),
                status: 'status',
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
