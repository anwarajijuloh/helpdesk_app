import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpdesk_app/models/person_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/helper/crypt_helper.dart';
import '../config/helper/service_calback.dart';

class AuthRepository {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<ServiceCallback> authSignUp({required Person person}) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: "Registrasi berhasil. Silahkan lakukan login");
      await db
          .collection('person')
          .where('person', isEqualTo: person.username)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          serviceCallback = ServiceCallback(
              success: false, msg: 'Anda sudah terdaftar, silahkan melakukan login');
        }
      });

      if (serviceCallback.success == false) return serviceCallback;

      // encrypt password
      person.password = await CryptHelper.cryptText(person.password);

      // do register
      var addPerson = db
          .collection('person')
          .withConverter(
            fromFirestore: Person.fromFirestore,
            toFirestore: (Person person, options) => person.toFirestore(),
          )
          .doc();
      person.pid = addPerson.id;
      await addPerson.set(person).catchError((e) {
        serviceCallback = ServiceCallback(success: false, msg: "Serve error. Registrasi gagal.");
      });

      return serviceCallback;
    } catch (e) {
      return ServiceCallback(success: false, msg: "Terjadi kesalahan. Registrasi gagal");
    }
  }

  static Future<ServiceCallback> authSignIn({
    required String username,
    required String password,
  }) async {
    try {
      ServiceCallback serviceCallback = ServiceCallback(success: true, msg: 'Login berhasil');

      final personRef = await db
          .collection('person')
          .withConverter(
              fromFirestore: Person.fromFirestore,
              toFirestore: (Person person, options) => person.toFirestore())
          .where('username', isEqualTo: username)
          .get();

      if (serviceCallback.success) {
        if (personRef.docs.isEmpty) {
          return ServiceCallback(
              success: false, msg: "User dengan username '$username' tidak ditemukan.");
        }
        final personData = personRef.docs[0].data();

        final checkPassword = await CryptHelper.cryptCheck(personData.password, password);
        if (!checkPassword) {
          return ServiceCallback(success: false, msg: 'Login failed. Password salah');
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pid', personData.pid);
        await prefs.setString('person_name', personData.nama);
        await prefs.setString('username', personData.username);
        if (personData.bagian != null) await prefs.setString('bagian', personData.bagian!);
        await prefs.setString('role', personData.role);
      }

      return serviceCallback;
    } catch (e) {
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Login gagal');
    }
  }

  static Future<ServiceCallback> authSignout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.reload();
    if (prefs.containsKey('pid')) {
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Logout failed');
    } else {
      return ServiceCallback(success: true, msg: 'Logged out.');
    }
  }

  static Future<ServiceCallback> generatePassword({
    required String password,
  }) async {
    try {
      final encryptedPassword = await CryptHelper.cryptText(password);
      return ServiceCallback(success: false, msg: encryptedPassword);
    } catch (e) {
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan generate user');
    }
  }

  static Future<ServiceCallback> resetPassword({
    required String username,
    required String newPassword,
  }) async {
    try {
      final encNewPass = await CryptHelper.cryptText(newPassword);
      ServiceCallback serviceCallback = ServiceCallback(success: true, msg: 'Reset password berhasil!');
      await db.collection('person').where('username', isEqualTo: username).get().then(
          (querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          serviceCallback = ServiceCallback(success: false, msg: 'Username tidak ditemukan!');
        } else {
          for (var docSnapshot in querySnapshot.docs) {
            db.collection('person').doc(docSnapshot.id).update({'password': encNewPass}).then(
                (value) {
              serviceCallback = ServiceCallback(success: true, msg: 'Password berhasil di reset!');
            }, onError: (e) {
              serviceCallback =
                  ServiceCallback(success: false, msg: 'Terjadi kesalahan reset password.');
            });
          }
        }
      }, onError: (e) {
        serviceCallback = ServiceCallback(success: false, msg: 'Terjadi kesalahan mengambil data.');
      });

      return serviceCallback;
    } catch (e) {
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Reset password gagal');
    }
  }
}