import 'package:flutter/material.dart';
import 'package:helpdesk_app/components/my_auth_header.dart';
import 'package:helpdesk_app/components/my_elevated_button.dart';
import 'package:helpdesk_app/components/my_text_form_field.dart';
import 'package:helpdesk_app/config/constants.dart';
import 'package:helpdesk_app/repositories/auth_repository.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _key = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _key,
            child: Column(
              children: [
                heightXL,
                const MyAuthHeader(
                  title: 'Sign In',
                  subtitle: 'Masuk terlebih dahulu!',
                ),
                heightM,
                MyTextFormField(
                  controller: _usernameController,
                  hintText: 'Username',
                  isObscured: false,
                  icons: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
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
                    if (value!.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                heightS,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/resetpass_page'),
                      child: const Text(
                        'Lupa password?',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                heightS,
                MyElevatedButton(
                  title: 'sign in',
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      AuthRepository.authSignIn(
                        username: _usernameController.text,
                        password: _passwordController.text,
                      ).then(
                        (res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.success) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/',
                              (route) => false,
                            );
                            _usernameController.clear();
                            _passwordController.clear();
                          }
                        },
                      );
                    }
                  },
                ),
                heightM,
                TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/signup_page', (route) => false),
                  child: const Text('sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
