import 'package:cloud_firestore/cloud_firestore.dart';

class Submission {
  String sid;
  String title;
  String deskripsi;
  String rid;
  DateTime createTime;
  String? status;

  Submission({
    required this.sid,
    required this.title,
    required this.deskripsi,
    required this.rid,
    required this.createTime,
    this.status,
  });

  factory Submission.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final createTimeToStr = data?['create_time'].toDate().toString();
    return Submission(
      sid: data?['sid'],
      title: data?['title'],
      deskripsi: data?['deskripsi'],
      rid: data?['rid'],
      createTime: DateTime.parse(createTimeToStr!),
      status: data?['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "sid": sid,
      "title": title,
      "deskripsi": deskripsi,
      "rid": rid,
      "create_time": createTime,
      "status": status,
    };
  }
}