import 'package:flutter/material.dart';

import '../../components/my_elevated_button.dart';
import '../../components/my_text_field.dart';
import '../../config/constants.dart';
import '../../models/report_progress_model.dart';
import '../../repositories/report_progress_repository.dart';

class AddProgressReportPage extends StatelessWidget {
  final ReportProgress? reportProgress;
  final String rid;
  const AddProgressReportPage(
      {super.key, required this.rid, this.reportProgress});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _deskripsiController = TextEditingController();
    final _estimateController = TextEditingController();
    final _dropdownController = TextEditingController();

    bool isUpdate = false;

    List<String> labelList = <String>[
      'Menit',
      'Jam',
      'Hari',
      'Minggu',
      'Bulan',
    ];
    ReportProgress? _reportProgress = reportProgress;
    if (_reportProgress != null) {
      _titleController.text = _reportProgress.title;
      _deskripsiController.text = _reportProgress.deskripsi;
      _estimateController.text = _reportProgress.estimasi!;
      _dropdownController.text = _reportProgress.satuanEstimasi!;
      isUpdate = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: isUpdate
            ? const Text(
                'Tambah Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: greenPrimary,
                ),
              )
            : const Text(
                'Tambah Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: greenPrimary,
                ),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                heightM,
                MyTextField(
                  controller: _titleController,
                  labelText: 'Judul Progress',
                  hintText: 'Masukkan Judul',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Judul tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                heightM,
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: DropdownMenu<String>(
                        controller: _dropdownController,
                        hintText: 'Pilih waktu',
                        inputDecorationTheme: const InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(width: 0.8),
                          ),
                          contentPadding: EdgeInsets.all(18),
                          fillColor: greenSecondary,
                          filled: true,
                          hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: greenPrimary,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        expandedInsets: EdgeInsets.zero,
                        dropdownMenuEntries: labelList
                            .map<DropdownMenuEntry<String>>((String depLabel) {
                          return DropdownMenuEntry<String>(
                            value: depLabel,
                            label: depLabel,
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: MyTextField(
                        controller: _estimateController,
                        hintText: 'Estimasi',
                        labelText: 'Estimasi',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Estimasi tidak boleh kosong!';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                heightM,
                MyTextField(
                  controller: _deskripsiController,
                  labelText: 'Keterangan',
                  hintText: 'Masukkan Keterangan',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'keterangan tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                heightL,
                MyElevatedButton(
                  title: isUpdate ? 'Update Progress' : 'Tambah Progress',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ReportProgress reportProgress = ReportProgress(
                        rpid: '',
                        title: _titleController.text,
                        deskripsi: _deskripsiController.text,
                        createTime: DateTime.now(),
                        rid: rid,
                        estimasi: _estimateController.text,
                        satuanEstimasi: _dropdownController.text,
                      );
                      if (isUpdate == true) {
                        reportProgress.rpid = _reportProgress!.rpid;
                        ReportProgressRepository.updateReportProgress(
                                reportProgress: reportProgress)
                            .then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        ReportProgressRepository.addReportProgress(
                                reportProgress: reportProgress)
                            .then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
