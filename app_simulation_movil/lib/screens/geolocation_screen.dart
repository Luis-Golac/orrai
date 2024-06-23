import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationScreen extends StatefulWidget {
  const GeolocationScreen({super.key});

  @override
  State<GeolocationScreen> createState() => _GeolocationScreenState();
}

class _GeolocationScreenState extends State<GeolocationScreen> {
  Future<Position> determinatePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinatePosition();
    print("============${position.latitude}");
    print("============${position.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geolocator"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              print("hola");
            },
            child: const Text("hola"),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                getCurrentLocation();
              },
              child: const Text("Tomar Location"),
            ),
          ),
        ],
      ),
    );
  }
}
