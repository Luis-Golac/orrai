import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animated_marker/flutter_map_animated_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiYW5nZWxtb3JhIiwiYSI6ImNseGxkcWxvaDA3enAyaXB0OGliMXN3MW0ifQ.LSGB5uag_ENPsqt_wtSmzg';

const initialPosition = LatLng(-5.091631422699464, -81.09300834514532);
// y          x
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  LatLng _currentPosition = initialPosition;
  late final MapController _mapController;
  final double _currentZoom = 18.0;

  final List<LatLng> _positions = [
    const LatLng(-5.091631422699464, -81.09300834514532), // Initial Position
    const LatLng(-5.090401209272173, -81.09236175623612),
  ];

  late AnimationController _animationController;
  late Animation<LatLng> _animation;
  int _currentPositionIndex = 0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _setupAnimation();
  }

  void _showSimpleDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          body: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Alerta',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    decoration: null,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> getMessageAlert() async {
    final response = await http.post(
      Uri.parse('https://api-ia-1b6f.onrender.com/crear_mensaje/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "nombre": "Mafer",
          "evento": "Incendio",
          "distancia": 100,
          "familiar": "",
          "hora": "${DateTime.now().hour}:${DateTime.now().minute}",
          "ubicacion": "https://maps.app.goo.gl/2WYoVhsqXTUJas5d7",
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["mensaje"];
    }
    return null;
  }

  Future<void> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(
          "https://stg1hb7vwl.execute-api.us-east-1.amazonaws.com/v1/api1"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "message": message,
        },
      ),
    );
  }

  void _setupAnimation() async {
    await Future.delayed(const Duration(seconds: 2));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = Tween<LatLng>(
      begin: _positions[_currentPositionIndex],
      end: _positions[_currentPositionIndex + 1],
    ).animate(_animationController)
      ..addListener(() {
        setState(() {
          _currentPosition = _animation.value;
          _mapController.move(_currentPosition, _currentZoom);
        });
      })
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          _currentPositionIndex++;
          if (_currentPositionIndex < _positions.length - 1) {
            _animateToNextPosition();
          }
          if (_currentPositionIndex == 1) {
            await Future.delayed(const Duration(milliseconds: 9050));
            var response = await getMessageAlert();
            await sendMessage("hola");
            _showSimpleDialog(context, response.toString());
          }
        }
      });

    _animateToNextPosition();
  }

  void _animateToNextPosition() {
    if (_currentPositionIndex < _positions.length - 1) {
      _animation = Tween<LatLng>(
        begin: _positions[_currentPositionIndex],
        end: _positions[_currentPositionIndex + 1],
      ).animate(_animationController);

      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mapa"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: initialPosition,
          minZoom: 5,
          maxZoom: 25,
          initialZoom: _currentZoom,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: const {
              'accessToken': MAPBOX_ACCESS_TOKEN,
              'id': 'mapbox/streets-v12'
            },
          ),
          Stack(
            children: [
              MarkerLayer(markers: [
                Marker(
                  height: 290,
                  width: 290,
                  point: const LatLng(-5.089789665698049, -81.0925974917647),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(84, 255, 134, 68),
                    ),
                  ),
                ),
              ]),
              const MarkerLayer(markers: [
                Marker(
                  height: 40,
                  width: 40,
                  point: LatLng(-5.089789665698049, -81.0925974917647),
                  child: Icon(
                    Icons.fire_truck,
                    color: Color.fromARGB(255, 255, 112, 64),
                    size: 50,
                  ),
                ),
              ]),
            ],
          ),
          AnimatedMarkerLayer(
            options: AnimatedMarkerLayerOptions(
              duration: const Duration(seconds: 9),
              marker: Marker(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                point: LatLng(
                  _currentPosition.latitude,
                  _currentPosition.longitude,
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: 0,
                    child: const Icon(
                      Icons.person_pin,
                      color: Colors.blueAccent,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
