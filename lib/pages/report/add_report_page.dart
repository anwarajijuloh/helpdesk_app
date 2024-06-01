import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helpdesk_app/components/my_text_form_field.dart';
import 'package:helpdesk_app/repositories/report_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/my_elevated_button.dart';
import '../../config/constants.dart';
import '../../models/report_model.dart';

class AddReportPage extends StatefulWidget {
  final Report? report;
  const AddReportPage({super.key, this.report});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _jenisController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _catatanController = TextEditingController();

  bool isUpdate = false;

  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image picked!');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image picked!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isUpdate = widget.report != null;
    final report = widget.report;
    String? imageFromDB;

    if (report != null) {
      _titleController.text = report.title;
      _jenisController.text = report.jenis;
      _deskripsiController.text = report.deskripsi;
      _catatanController.text = report.catatan ?? '';
      imageFromDB = report.image;
    }

    String title = isUpdate ? 'Update Laporan' : 'Tambah Laporan';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
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
                MyTextFormField(
                  controller: _titleController,
                  hintText: 'Tambah judul',
                  icons: Icons.card_membership,
                  isObscured: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Judul tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                heightM,
                MyTextFormField(
                  controller: _jenisController,
                  hintText: 'Tambah jenis',
                  icons: Icons.type_specimen,
                  isObscured: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Jenis tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                heightM,
                MyTextFormField(
                  controller: _deskripsiController,
                  hintText: 'Tambah deskripsi',
                  icons: Icons.description,
                  isObscured: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                heightM,
                MyTextFormField(
                  controller: _catatanController,
                  hintText: 'Tambah catatan',
                  icons: Icons.note_add,
                  isObscured: false,
                ),
                heightM,
                heightL,
                MyElevatedButton(
                  title: title,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Report newReport = Report(
                        rid: '',
                        title: _titleController.text,
                        jenis: _jenisController.text,
                        deskripsi: _deskripsiController.text,
                        catatan: _catatanController.text,
                        pid: '',
                        createTime: DateTime.now(),
                        status: 'Diterima',
                      );
                      if (_image != null) {
                        await ReportRepository.uploadImage(imageFile: _image)
                            .then((res) {
                          if (res.data != null) {
                            newReport.image = res.data;
                          }
                        });
                      } else {
                        newReport.image = imageFromDB;
                      }

                      if (isUpdate) {
                        final prefs = await SharedPreferences.getInstance();
                        final pid = prefs.getString('pid');
                        newReport.rid = report!.rid;
                        newReport.pid = pid!;
                        await ReportRepository.updateReport(report: newReport)
                            .then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.isNotLogin == true) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/signin_page', (route) => false);
                          }
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        if (_image == null) {
                          newReport.image = null;
                        }
                        await ReportRepository.addReport(report: newReport)
                            .then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.isNotLogin == true) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/signin_page', (route) => false);
                          }
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      }
                    }
                  },
                ),
                heightM,
                TextButton(
                  onPressed: () {
                    _showPicker(context);
                  },
                  child: const Text('Upload Image'),
                ),
                heightM,
                _image != null
                    ? ImageSelected(
                        myWidget: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : (imageFromDB != null && _image == null)
                        ? ImageSelected(
                            myWidget:
                                Image.network(imageFromDB, fit: BoxFit.cover),
                          )
                        : imageField(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container imageField() {
    return Container(
      height: 200,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: greenSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: 60,
            color: greenPrimary,
          ),
          heightS,
          Text(
            'No Image',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: grey3,
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Ambil dari gallery'),
                onTap: () {
                  imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dari kamera'),
                onTap: () {
                  imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ImageSelected extends StatelessWidget {
  final Widget myWidget;
  const ImageSelected({
    super.key,
    required this.myWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.maxFinite,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: myWidget,
      ),
    );
  }
}
