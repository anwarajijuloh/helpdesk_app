import 'package:cloud_firestore/cloud_firestore.dart';

class ReportProgress {
  String rpid;
  String title;
  String deskripsi;
  DateTime createTime;
  String rid;
  String? estimasi;
  String? satuanEstimasi;

  ReportProgress({
    required this.rpid,
    required this.title,
    required this.deskripsi,
    required this.createTime,
    required this.rid,
    this.estimasi,
    this.satuanEstimasi,
  });

  factory ReportProgress.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final createTimeToStr = data?['create_time'].toDate().toString();
    return ReportProgress(
      rpid: data?['rpid'],
      title: data?['title'],
      deskripsi: data?['deskripsi'],
      createTime: DateTime.parse(createTimeToStr!),
      rid: data?['rid'],
      estimasi: data?['estimasi'],
      satuanEstimasi: data?['satuan_estimasi'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "rpid": rpid,
      "title": title,
      "deskripsi": deskripsi,
      "create_time": createTime,
      "rid": rid,
      "estimasi": estimasi,
      "satuan_estimasi": satuanEstimasi,
    };
  }
}