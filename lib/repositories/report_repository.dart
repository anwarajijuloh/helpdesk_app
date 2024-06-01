import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

import '../config/helper/service_calback.dart';
import '../models/report_model.dart';

class RanKeyAssets {
  var largeAlphabets = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  var digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
}

class ReportRepository {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<ServiceCallback> addReport({required Report report}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pid = prefs.getString('pid');
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Laporan berhasil di kirim');

      if (pid == null) {
        return ServiceCallback(
            success: false,
            msg: 'Authentication error. Harap login terlebih dahulu',
            isNotLogin: true);
      }

      randomIdGenerator(){
        var ranKey = RanKeyAssets();
        var key = '';
        var char = '';
        for (var i = 0; i < 2; i++) {
          char += ranKey.largeAlphabets[Random().nextInt(ranKey.largeAlphabets.length)];
          key += ranKey.digits[Random().nextInt(10)];
        }
        return '$char$key';
      }
      var repID = "PN${DateTime.now().day}${DateTime.now().month}${randomIdGenerator()}";

      report.pid = pid;
      var addReportRef = db
          .collection('report')
          .withConverter(
              fromFirestore: Report.fromFirestore,
              toFirestore: (Report report, options) => report.toFirestore())
          .doc(repID);
      report.rid = addReportRef.id;
      await addReportRef.set(report).catchError((e) {
        print(e);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. laporan gagal dikirim');
      });

      return serviceCallback;
    } catch (e) {
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Laporan gagal dikirim');
    }
  }

  static Future<ServiceCallback> deleteReport({
    required rid,
  }) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Laporan berhasil dihapus');
      db.collection('rid').doc(rid).delete().catchError((e) {
        print(e);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. Laporan gagal dihapus');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Laporan gagal dihapus');
    }
  }

  static Future<ServiceCallback> updateReport({required Report report}) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Laporan berhasil di update');
      var updateReportRef = db
          .collection('report')
          .withConverter(
              fromFirestore: Report.fromFirestore,
              toFirestore: (Report report, options) => report.toFirestore())
          .doc(report.rid);
      await updateReportRef.set(report).catchError((e) {
        print(e);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. Laporan gagal di udate');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Gagal update laporan');
    }
  }

  static Future<ServiceCallback> updateStatus({
    required String status,
    required String rid,
  }) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Status berhasil di update');
      var newDataStatus = {'status': status};
      var updateStatusRef = db.collection('report').doc(rid);
      await updateStatusRef
          .set(newDataStatus, SetOptions(merge: true))
          .catchError((e) {
        print(e);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. Status gagal di update');
      });
      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Status gagal di update');
    }
  }

  static Future<ServiceCallback> uploadImage({
    required File? imageFile,
  }) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Berhasil upload file');

      String? imageUrl;
      if (imageFile != null) {
        final fileName = basename(imageFile.path);

        final ref = FirebaseStorage.instance.ref("images").child(fileName);
        await ref.putFile(imageFile);

        imageUrl = await ref.getDownloadURL();
        serviceCallback = ServiceCallback(
            success: true, msg: 'Berhasil upload file', data: imageUrl);
      } else {
        serviceCallback = ServiceCallback(
            success: true, msg: 'Berhasil upload file', data: null);
      }

      return serviceCallback;
    } catch (e) {
      // print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Upload file gagal');
    }
  }
}
