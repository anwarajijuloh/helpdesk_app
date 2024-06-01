import 'package:flutter/material.dart';

import '../../components/my_auth_header.dart';
import '../../components/my_elevated_button.dart';
import '../../components/my_text_form_field.dart';
import '../../config/constants.dart';
import '../../repositories/auth_repository.dart';

class ResetPassPage extends StatefulWidget {
  const ResetPassPage({super.key});

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  heightXL,
                  const MyAuthHeader(
                    title: 'Reset Pass',
                    subtitle: 'Ganti kata sandi anda berkala!',
                  ),
                  heightM,
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
                    controller: _newPasswordController,
                    hintText: 'Kata Sandi',
                    isObscured: true,
                    icons: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value != _confirmPasswordController.text) {
                        return "Password tidak sama";
                      }
                      return null;
                    },
                  ),
                  heightS,
                  MyTextFormField(
                    controller: _confirmPasswordController,
                    hintText: 'Ulang Kata Sandi',
                    isObscured: true,
                    icons: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) 
                        return "Konfirmasi Password tidak boleh kosong";
                      
                      if (value != _newPasswordController.text) 
                        return "Password tidak sama";
                      
                      return null;
                    },
                  ),
                  heightM,
                  MyElevatedButton(
                    title: 'konfirmasi',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        AuthRepository.resetPassword(username: _usernameController.text, newPassword: _newPasswordController.text).then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.success) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/signin_page', (route) => false);
                          }
                        });
                      }
                    },
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
