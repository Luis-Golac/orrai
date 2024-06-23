import 'package:flutter/material.dart';
//import 'package:hackaton_2024/screens/auth_screen.dart';
import 'package:hackaton_2024/screens/map_screen.dart';
//import 'package:hackaton_2024/screens/geolocation_screen.dart';
//import 'package:hackaton_2024/screens/login_screen.dart';
//import 'package:hackaton_2024/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}
