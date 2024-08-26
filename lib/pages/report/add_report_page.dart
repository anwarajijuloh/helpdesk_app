import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/my_elevated_button.dart';
import '../../components/my_text_field.dart';
import '../../config/constants.dart';
import '../../models/person_model.dart';
import '../../models/report_model.dart';
import '../../repositories/report_repository.dart';

class AddReportPage extends StatefulWidget {
  final Report? report;
  const AddReportPage({super.key, this.report});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

List<String> labelList = <String>[
  'Hardware',
  'Software',
  'Jaringan',
  'Tidak diketahui',
];

class _AddReportPageState extends State<AddReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _jenisController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _catatanController = TextEditingController();

  bool isUpdate = false;
  bool isLoading = false;

  String? selectedSerialNumber;
  List<String> serialNumbers = [];

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
  void initState() {
    super.initState();
    _loadPersonData();
  }

  Future<void> _loadPersonData() async {
    final prefs = await SharedPreferences.getInstance();
    final pid = prefs.getString('pid');

    if (pid != null) {
      final docSnapshot = await FirebaseFirestore.instance.collection('person').doc(pid).get();
      final person = Person.fromFirestore(docSnapshot, null);
      
      setState(() {
        serialNumbers = person.serialNumbers ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isUpdate = widget.report != null;
    final report = widget.report;
    String? imageFromDB;

    if (report != null) {
      _titleController.text = report.title;
      _jenisController.text = report.jenis;
      _serialNumberController.text = report.serialNumber;
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
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      heightM,
                      MyTextField(
                        controller: _titleController,
                        hintText: 'Tambah judul',
                        labelText: 'Judul',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Judul tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      heightM,
                      DropdownMenu<String>(
                        controller: _jenisController,
                        hintText: 'Jenis',
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
                      heightM,
                      DropdownMenu<String>(
                        controller: _serialNumberController,
                        hintText: 'Pilih Serial Number',
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
                        dropdownMenuEntries: serialNumbers
                            .map<DropdownMenuEntry<String>>((String serial) {
                          return DropdownMenuEntry<String>(
                            value: serial,
                            label: serial,
                          );
                        }).toList(),
                      ),
                      heightM,
                      MyTextField(
                        controller: _deskripsiController,
                        hintText: 'Tambah deskripsi',
                        labelText: 'Deskripsi',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Deskripsi tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                      heightM,
                      MyTextField(
                        controller: _catatanController,
                        hintText: 'Tambah catatan',
                        labelText: 'Catatan',
                      ),
                      heightM,
                      _image != null
                          ? ImageSelected(
                              myWidget: Image.file(_image!, fit: BoxFit.cover),
                            )
                          : (imageFromDB != null && _image == null)
                              ? ImageSelected(
                                  myWidget: Image.network(imageFromDB,
                                      fit: BoxFit.cover),
                                )
                              : imageField(context),
                      heightL,
                      MyElevatedButton(
                        title: title,
                        onPressed: isLoading == true
                            ? null
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });
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
                                    serialNumber: _serialNumberController.text,
                                  );
                                  if (_image != null) {
                                    await ReportRepository.uploadImage(
                                            imageFile: _image)
                                        .then((res) {
                                      if (res.data != null) {
                                        newReport.image = res.data;
                                      }
                                    });
                                  } else {
                                    newReport.image = imageFromDB;
                                  }

                                  if (isUpdate) {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final pid = prefs.getString('pid');
                                    newReport.rid = report!.rid;
                                    newReport.pid = pid!;
                                    await ReportRepository.updateReport(
                                            report: newReport)
                                        .then((res) {
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(
                                            SnackBar(content: Text(res.msg)));
                                      if (res.isNotLogin == true) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/signin_page',
                                            (route) => false);
                                      }
                                      if (res.success) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  } else {
                                    if (_image == null) {
                                      newReport.image = null;
                                    }

                                    await ReportRepository.addReport(
                                            report: newReport)
                                        .then((res) {
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(
                                            SnackBar(content: Text(res.msg)));
                                      if (res.isNotLogin == true) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/signin_page',
                                            (route) => false);
                                      }

                                      if (res.success) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  GestureDetector imageField(context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: Container(
        height: 200,
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(),
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
              'Upload Image',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: grey3,
              ),
            ),
          ],
        ),
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
