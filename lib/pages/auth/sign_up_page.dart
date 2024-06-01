import 'package:flutter/material.dart';
import 'package:helpdesk_app/repositories/auth_repository.dart';

import '../../components/my_auth_header.dart';
import '../../components/my_elevated_button.dart';
import '../../components/my_text_form_field.dart';
import '../../config/constants.dart';
import '../../models/person_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

List<String> labelList = <String>[
  'OPS1',
  'OPS2',
  'Sekper',
  'SPI',
  'Akutansi',
  'Renstra',
  'Pengadaan',
  'IT',
  'Opset',
  'Pemasaran',
  'ACS',
];

class _SignUpPageState extends State<SignUpPage> {
  final _key = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _bagianController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  heightXL,
                  const MyAuthHeader(
                    title: 'Sign Up',
                    subtitle: 'Buat akun anda!',
                  ),
                  heightM,
                  MyTextFormField(
                    controller: _namaController,
                    hintText: 'Nama Lengkap',
                    isObscured: false,
                    icons: Icons.person_pin_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  heightS,
                  DropdownMenu<String>(
                    controller: _bagianController,
                    hintText: 'Pilih posisi',
                    leadingIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Icon(Icons.work),
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
                  heightS,
                  MyTextFormField(
                    controller: _usernameController,
                    hintText: 'Username',
                    isObscured: false,
                    icons: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  heightS,
                  MyTextFormField(
                    controller: _passwordController,
                    hintText: '******',
                    isObscured: true,
                    icons: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  heightM,
                  MyElevatedButton(
                    title: 'sign up',
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        var person = Person(
                          pid: '',
                          nama: _namaController.text,
                          username: _usernameController.text,
                          password: _passwordController.text,
                          bagian: _bagianController.text,
                          role: 'Karyawan',
                        );
                        AuthRepository.authSignUp(person: person).then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.success) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/signin_page',
                              (route) => false,
                            );
                            _namaController.clear();
                            _bagianController.clear();
                            _usernameController.clear();
                            _passwordController.clear();
                          }
                        });
                      }
                    },
                  ),
                  heightM,
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/signin_page', (route) => false),
                    child: const Text('sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
