import 'package:flutter/material.dart';

import '../../models/report_model.dart';

class SearchReportPage extends StatefulWidget {
  final Report? report;
  const SearchReportPage({super.key, this.report});

  @override
  State<SearchReportPage> createState() => _SearchReportPageState();
}

class _SearchReportPageState extends State<SearchReportPage> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
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
      body: Center(
        child: Text('Belum ada hasil'),
      ),
    );
  }
}
