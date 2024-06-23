import 'package:flutter/material.dart';
import 'package:hackaton_2024/components/custom_button_lr.dart';
import 'package:hackaton_2024/components/custom_input.dart';
import 'package:hackaton_2024/schemas/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  User user = User();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void updateUser() {
    setState(() {
      user.username = _usernameController.text;
      user.password = _passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: CustomInput(
              label: "usuario",
              isPassword: false,
              prefixIcon: Icons.person,
              controller: _usernameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: CustomInput(
              label: "Correo",
              isPassword: false,
              prefixIcon: Icons.email,
              controller: _emailController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: CustomInput(
              label: "Número de celular",
              isPassword: false,
              prefixIcon: Icons.phone,
              controller: _phoneNumberController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: CustomInput(
              label: "password",
              isPassword: true,
              prefixIcon: Icons.lock,
              controller: _passwordController,
            ),
          ),
          CustomButtonLR(
            username: _usernameController.text,
            password: _passwordController.text,
            loginType: false,
            email: _emailController.text,
            phoneNumber: _phoneNumberController.text,
          ),
        ],
      ),
    );
  }
}
