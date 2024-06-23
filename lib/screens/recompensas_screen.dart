import 'package:flutter/material.dart';

class RecompensasScreen extends StatelessWidget {
  const RecompensasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Image.asset(
        'assets/images/recompensas_screen.jpeg',
        fit: BoxFit.contain,
      ),
    );
  }
}
