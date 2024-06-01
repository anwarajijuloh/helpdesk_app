import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String rid;
  String title;
  String jenis;
  String deskripsi;
  String? catatan;
  String pid;
  DateTime createTime;
  String status;
  String? image;

  Report({
    required this.rid,
    required this.title,
    required this.jenis,
    required this.deskripsi,
    required this.catatan,
    required this.pid,
    required this.createTime,
    required this.status,
    this.image,
  });

  factory Report.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final createTimeToStr = data?['create_time'].toDate().toString();
    return Report(
      rid: data?['rid'],
      title: data?['title'],
      jenis: data?['jenis'],
      deskripsi: data?['deskripsi'],
      catatan: data?['catatan'],
      pid: data?['pid'],
      createTime: DateTime.parse(createTimeToStr!),
      status: data?['status'],
      image: data?['image'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "rid": rid,
      "title": title,
      "jenis": jenis,
      "deskripsi": deskripsi,
      "catatan": catatan,
      "pid": pid,
      "create_time": createTime,
      "status": status,
      "image": image,
    };
  }
}