import 'package:flutter/material.dart';
import 'package:helpdesk_app/models/submission_model.dart';

import '../../components/my_elevated_button.dart';
import '../../components/my_text_field.dart';
import '../../config/constants.dart';
import '../../repositories/submission_repository.dart';

class AddSubmissionReportPage extends StatefulWidget {
  final String rid;
  final Submission? submission;
  const AddSubmissionReportPage(
      {super.key, required this.rid, this.submission});

  @override
  State<AddSubmissionReportPage> createState() =>
      _AddSubmissionReportPageState();
}

class _AddSubmissionReportPageState extends State<AddSubmissionReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool isUpdate = false;

  @override
  Widget build(BuildContext context) {
    Submission? _submission = widget.submission;
    if (_submission != null) {
      _titleController.text = _submission.title;
      _descriptionController.text = _submission.deskripsi;
      isUpdate = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: isUpdate
            ? const Text(
                'Update Pengajuan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: greenPrimary,
                ),
              )
            : const Text(
                'Tambah Pengajuan',
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
                    labelText: 'Judul',
                    hintText: 'Judul Pengajuan',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    }),
                heightM,
                MyTextField(
                    controller: _descriptionController,
                    labelText: 'Keterangan',
                    hintText: 'Keterangan Pengajuan',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Keterangan tidak boleh kosong';
                      }
                      return null;
                    }),
                heightL,
                MyElevatedButton(
                  title: isUpdate ? 'Update Ajuan' : 'Tambah Ajuan',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Submission submission = Submission(
                        sid: '',
                        title: _titleController.text,
                        deskripsi: _descriptionController.text,
                        rid: widget.rid,
                        status: 'Terkirim',
                        createTime: DateTime.now(),
                      );
                      if (isUpdate) {
                        submission.sid = _submission!.sid;
                        submission.status = _submission.status;
                        SubmissionRepository.updateSubmission(
                                submission: submission)
                            .then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        SubmissionRepository.addSubmission(
                                submission: submission)
                            .then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      }
                      Navigator.pop(context, _submission);
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
