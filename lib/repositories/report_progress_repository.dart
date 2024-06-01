import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/helper/service_calback.dart';
import '../models/report_progress_model.dart';

class ReportProgressRepository {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<ServiceCallback> addReportProgress(
      {required ReportProgress reportProgress}) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Progress berhasil ditambahkan');

      var addProgressRef = db
          .collection('report_progress')
          .withConverter(
              fromFirestore: ReportProgress.fromFirestore,
              toFirestore: (ReportProgress reportProgress, options) =>
                  reportProgress.toFirestore())
          .doc();
      reportProgress.rpid = addProgressRef.id;
      await addProgressRef.set(reportProgress).catchError((e) {
        print(e);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server Error. Gagal tambah progress');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Gagal tambah progress');
    }
  }

  static Future<ServiceCallback> updateReportProgress(
      {required ReportProgress reportProgress}) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Update progress berhasil');
      var updateProgressRef = db
          .collection('report_progress')
          .withConverter(
              fromFirestore: ReportProgress.fromFirestore,
              toFirestore: (ReportProgress reportProgress, options) =>
                  reportProgress.toFirestore())
          .doc(reportProgress.rpid);
      await updateProgressRef.set(reportProgress).catchError((e) {
        print(e);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server Error. Gagal update progress');
      });
      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Update Progress gagal');
    }
  }

  static Future<ServiceCallback> deleteReportProgress(
      {required String rpid}) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Progress berhasil dihapus');
      var deleteProgressRef = db
          .collection('report_progress')
          .withConverter(
              fromFirestore: ReportProgress.fromFirestore,
              toFirestore: (ReportProgress reportProgress, options) =>
                  reportProgress.toFirestore())
          .doc(rpid);
      await deleteProgressRef.delete().catchError((e) {
        print(e);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server Error. Gagal menghapus progress');
      });
      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Gagal menghapus progress');
    }
  }
}
