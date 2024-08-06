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
                Row(
                  children: [
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
                    const SizedBox(width: 10),
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
                  ],
                ),
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
                        estimasi: _estimateController.text,
                        satuanEstimasi: _dropdownController.text,
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
