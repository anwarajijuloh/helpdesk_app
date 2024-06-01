import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/helper/service_calback.dart';
import '../models/submission_model.dart';

class SubmissionRepository {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<ServiceCallback> addSubmission(
      {required Submission submission}) async {
    try {
      var serviceCallback =
          ServiceCallback(success: true, msg: 'Pengajuan berhasil dibuat');
      var addSubmissionRef = db
          .collection('submission')
          .withConverter(
              fromFirestore: Submission.fromFirestore,
              toFirestore: (Submission submission, options) =>
                  submission.toFirestore())
          .doc();
      submission.sid = addSubmissionRef.id;
      await addSubmissionRef.set(submission).catchError((err) {
        print(err);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. Pengajuan gagal dibuat');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Pengajuan gagal dikirim');
    }
  }

  static Future<ServiceCallback> updateSubmission({required Submission submission}) async {
    try {
      var serviceCallback =
          ServiceCallback(success: true, msg: 'Pengajuan berhasil diubah');
      var updateSubmissionRef = db
         .collection('submission')
         .withConverter(
              fromFirestore: Submission.fromFirestore,
              toFirestore: (Submission submission, options) =>
                  submission.toFirestore())
         .doc(submission.sid);
      await updateSubmissionRef.set(submission).catchError((err) {
        print(err);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. Pengajuan gagal diubah');
      });
      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Pengajuan gagal diubah');
    }
  }

  static Future<ServiceCallback> deleteSubmission({required String sid}) async {
    try {
      var serviceCallback =
          ServiceCallback(success: true, msg: 'Pengajuan berhasil dihapus');
      var deleteSubmissionRef = db
         .collection('submission')
         .withConverter(
              fromFirestore: Submission.fromFirestore,
              toFirestore: (Submission submission, options) =>
                  submission.toFirestore())
         .doc(sid);
      await deleteSubmissionRef.delete().catchError((err) {
        print(err);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. Pengajuan gagal dihapus');
      });
      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Pengajuan gagal dihapus');
    }
  }

  static Future<ServiceCallback> updateStatus({required String sid, required String status}) async {
    try {
      var serviceCallback =
          ServiceCallback(success: true, msg: 'Status pengajuan berhasil diubah');
      var updateStatusRef = db
         .collection('submission')
         .withConverter(
              fromFirestore: Submission.fromFirestore,
              toFirestore: (Submission submission, options) =>
                  submission.toFirestore())
         .doc(sid);
      await updateStatusRef.update({'status': status}).catchError((err) {
        print(err);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. Status pengajuan gagal diubah');
      });
      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Status pengajuan gagal diubah');
    }
  }
}
