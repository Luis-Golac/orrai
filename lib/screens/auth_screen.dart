import 'package:flutter/material.dart';
import 'package:hackaton_2024/screens/login_screen.dart';
import 'package:hackaton_2024/screens/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String isLogin = "login";

  @override
  void initState() {
    super.initState();
  }

  void toggleForm(String value) {
    setState(() {
      isLogin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.44,
                      child: FilledButton(
                        onPressed: () => {
                          toggleForm("login"),
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            isLogin == "login"
                                ? Colors.greenAccent
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          "Inicia Sesión",
                          style: TextStyle(
                            color: isLogin == "login"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.44,
                      child: FilledButton(
                        onPressed: () => {
                          toggleForm("register"),
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            isLogin == "register"
                                ? Colors.greenAccent
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          "Registrarse",
                          style: TextStyle(
                            color: isLogin == "register"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: isLogin == "login"
                    ? const LoginScreen()
                    : const RegisterScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
