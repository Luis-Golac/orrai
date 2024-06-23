import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomButtonLR extends StatefulWidget {
  final String username;
  final String password;
  final String? email;
  final String? phoneNumber;
  final bool loginType;
  const CustomButtonLR({
    super.key,
    required this.username,
    required this.password,
    required this.loginType,
    this.email,
    this.phoneNumber,
  });

  @override
  State<CustomButtonLR> createState() => _CustomButtonLRState();
}

class _CustomButtonLRState extends State<CustomButtonLR> {
  final String urlLogin =
      "https://nw7tvvpaf7.execute-api.us-west-2.amazonaws.com/prod/login-user";
  final String urlRegister =
      "https://nw7tvvpaf7.execute-api.us-west-2.amazonaws.com/prod/register";

  @override
  void initState() {
    super.initState();
  }

  Future<bool> validateCredentials() async {
    if (widget.loginType &&
        (widget.username.isEmpty || widget.password.isEmpty)) {
      print("entro al 1er if ${widget.username} ${widget.password}");
      return false;
    }

    if (!widget.loginType &&
        (widget.username.isEmpty ||
            widget.password.isEmpty ||
            widget.email!.isEmpty ||
            widget.phoneNumber!.isEmpty)) {
      print("entro al 2do if ${widget.username} ${widget.password}");
      return false;
    }

    if (widget.loginType) {
      print("entro al 3er if ${widget.username} ${widget.password}");
      final response = await http.post(
        Uri.parse(urlLogin),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            "username": widget.username, //"exampleUser",
            "password": widget.password, //"examplePassword",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["statusCode"] == 200) {
          return true;
        }
      }

      return false;
    }
    print("llego aqui");
    final response = await http.post(
      Uri.parse(urlRegister),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "username": widget.username,
          "password": widget.password,
          "email": widget.email!,
          "phone_number": widget.phoneNumber!,
          "favorites": [],
        },
      ),
    );
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data["statusCode"] == 200 || data["statusCode"] == 201) {
        return true;
      }
    }

    return false;
  }

  Future<void> login(BuildContext context) async {
    if (await validateCredentials()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            Colors.greenAccent,
          ),
        ),
        onPressed: () => login(context),
        child: const Text("Iniciar Sesión"),
      ),
    );
  }
}
