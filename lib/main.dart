import 'package:flutter/material.dart';
import 'package:hackaton_2024/screens/favorites_screen.dart';
import 'package:hackaton_2024/screens/map_screen.dart';
import 'package:hackaton_2024/screens/recompensas_screen.dart';
import 'package:hackaton_2024/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MapScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/recompensas': (context) => const RecompensasScreen(),
      },
    );
  }
}
