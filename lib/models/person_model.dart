import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String pid;
  String nama;
  String username;
  String password;
  String? bagian;
  String role;
  List<String>? serialNumbers;

  Person({
    required this.pid,
    required this.nama,
    required this.username,
    required this.password,
    required this.bagian,
    required this.role,
    this.serialNumbers,
  });

  factory Person.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Person(
      pid: data?['pid'],
      nama: data?['nama'],
      username: data?['username'],
      password: data?['password'],
      bagian: data?['bagian'],
      role: data?['role'],
      serialNumbers: data?['serialNumbers'] != null 
          ? List<String>.from(data?['serialNumbers']) 
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "pid": pid,
      "nama": nama,
      "username": username,
      "password": password,
      "bagian": bagian,
      "role": role,
      "serialNumbers": serialNumbers,
    };
  }
}