import 'package:flutter_map/flutter_map.dart';

class CMarkers {
  List<Marker> markers = [];

  CMarkers();

  List<Marker> addMarker(Marker value) {
    markers.add(value);
    print("lista: $markers");
    return markers;
  }

  getMarkers() {
    return markers;
  }
}
