import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animated_marker/flutter_map_animated_marker.dart';
import 'package:hackaton_2024/components/alert_dialog_with_state.dart';
import 'package:hackaton_2024/services/notification_service.dart';
import 'package:hackaton_2024/utils/markers.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animate_do/animate_do.dart';

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiYW5nZWxtb3JhIiwiYSI6ImNseGxkcWxvaDA3enAyaXB0OGliMXN3MW0ifQ.LSGB5uag_ENPsqt_wtSmzg';

const initialPosition = LatLng(-5.091631422699464, -81.09300834514532);
// y          x

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
  int _durationMarker = 9;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _setupAnimation();
    _markers = CMarkers().getMarkers();
  }

  void _showSimpleDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          body: SlideInUp(
            duration: const Duration(seconds: 2),
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white60,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/images/imag.png',
                    height: 150,
                  ),
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
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                  ),
                ],
              ),
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
          "https://xkpj5mrmn5.execute-api.us-east-1.amazonaws.com/prod/sms"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, dynamic>{
          "message": message,
        },
      ),
    );
    print(jsonDecode(response.body));
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
            await sendMessage(response.toString());
            _showSimpleDialog(context, response.toString());
            showNotification(response.toString());
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

  void _showDialogAddMarker(BuildContext context, LatLng position) async {
    final newMarker = await showDialog<List<Marker>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogWithState(
          position: position,
        );
      },
    );
    if (newMarker != null) {
      setState(() {
        _markers = newMarker;
      });
    }
  }

  void _addMarker(LatLng position) async {
    _showDialogAddMarker(context, position);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        maxRadius: 30,
                        child: Icon(
                          Icons.person_2_rounded,
                          size: 40,
                        ),
                      ),
                      Title(
                        color: Colors.white,
                        child: const Text(
                          "Mafer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.map_rounded),
                title: const Text("Mapa"),
                onTap: () => Navigator.pushNamed(context, '/'),
              ),
              ListTile(
                leading: const Icon(Icons.star_rounded),
                title: const Text("Favoritos"),
                onTap: () => Navigator.pushNamed(context, '/favorites'),
              ),
              ListTile(
                leading: const Icon(Icons.card_giftcard_rounded),
                title: const Text("Recompensas"),
                onTap: () => Navigator.pushNamed(context, '/recompensas'),
              )
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            "Bienvenida, Mafer",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: initialPosition,
                minZoom: 5,
                maxZoom: 25,
                initialZoom: _currentZoom,
                onTap: (tapPosition, point) {
                  _addMarker(point);
                },
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
                MarkerLayer(
                  markers: _markers,
                ),
                Stack(
                  children: [
                    MarkerLayer(markers: [
                      Marker(
                        height: 290,
                        width: 290,
                        point:
                            const LatLng(-5.089789665698049, -81.0925974917647),
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
                    duration: Duration(seconds: _durationMarker),
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
                            color: Colors.redAccent,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
