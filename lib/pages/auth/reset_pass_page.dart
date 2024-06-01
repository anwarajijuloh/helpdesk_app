import 'package:flutter/material.dart';

import '../../components/my_auth_header.dart';
import '../../components/my_elevated_button.dart';
import '../../components/my_text_form_field.dart';
import '../../config/constants.dart';

class ResetPassPage extends StatelessWidget {
  const ResetPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              heightXL,
              const MyAuthHeader(
                title: 'Reset Pass',
                subtitle: 'Ganti kata sandi anda berkala!',
              ),
              heightM,
              MyTextFormField(
                hintText: 'Username',
                isObscured: false,
                icons: Icons.person,
              ),
              heightS,
              MyTextFormField(
                hintText: 'Kata Sandi',
                isObscured: true,
                icons: Icons.lock,
              ),
              heightS,
              MyTextFormField(
                hintText: 'Ulang Kata Sandi',
                isObscured: true,
                icons: Icons.lock,
              ),
              heightM,
              MyElevatedButton(title: 'konfirmasi', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
