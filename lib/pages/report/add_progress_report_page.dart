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

    bool isUpdate = false;

    ReportProgress? _reportProgress = reportProgress;
    if (_reportProgress != null) {
      _titleController.text = _reportProgress.title;
      _deskripsiController.text = _reportProgress.deskripsi;
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
                      child: MyTextField(
                        controller: TextEditingController(),
                        hintText: 'Estimasi Jam',
                        labelText: 'Jam Estimasi',
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: MyTextField(
                        controller: TextEditingController(),
                        hintText: 'Estimasi Menit',
                        labelText: 'Menit Estimasi',
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
                      );
                      if (isUpdate) {
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
