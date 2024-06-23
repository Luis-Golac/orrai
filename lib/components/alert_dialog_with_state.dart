import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hackaton_2024/utils/markers.dart';
import 'package:latlong2/latlong.dart';

class AlertDialogWithState extends StatefulWidget {
  final LatLng position;
  const AlertDialogWithState({super.key, required this.position});

  @override
  State<AlertDialogWithState> createState() => _AlertDialogWithStateState();
}

class _AlertDialogWithStateState extends State<AlertDialogWithState> {
  String? checked = "Incendio";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccione el tipo de Evento'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: const Row(
              children: [
                Text('Incendio'),
                SizedBox(width: 8),
                Icon(
                  Icons.fire_truck,
                  color: Color.fromARGB(255, 255, 112, 64),
                ),
              ],
            ),
            leading: Radio<String>(
              value: "Incendio",
              groupValue: checked,
              onChanged: (String? value) {
                setState(() {
                  checked = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Row(
              children: [
                Text('Choque'),
                SizedBox(width: 8),
                Icon(
                  Icons.car_crash_rounded,
                  color: Colors.indigoAccent,
                ),
              ],
            ),
            leading: Radio<String>(
              value: "Choque",
              groupValue: checked,
              onChanged: (String? value) {
                setState(() {
                  checked = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Row(
              children: [
                Text('Inundación'),
                SizedBox(width: 8),
                Icon(
                  Icons.flood_rounded,
                  color: Colors.amberAccent,
                ),
              ],
            ),
            leading: Radio<String>(
              value: "Inundación",
              groupValue: checked,
              onChanged: (String? value) {
                setState(() {
                  checked = value;
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {});
            List<Marker> res = CMarkers().addMarker(
              Marker(
                point: widget.position,
                width: 150,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    color: checked == "Incendio"
                        ? const Color.fromARGB(103, 255, 112, 64)
                        : checked == "Choque"
                            ? const Color.fromARGB(103, 83, 109, 254)
                            : const Color.fromARGB(103, 255, 214, 64),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    checked == "Incendio"
                        ? Icons.fire_truck_rounded
                        : checked == "Choque"
                            ? Icons.car_crash_rounded
                            : Icons.flood_rounded,
                    color: checked == "Incendio"
                        ? const Color.fromARGB(255, 255, 112, 64)
                        : checked == "Choque"
                            ? Colors.indigoAccent
                            : Colors.amberAccent,
                    size: 40,
                  ),
                ),
              ),
            );
            Navigator.of(context).pop(res);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
