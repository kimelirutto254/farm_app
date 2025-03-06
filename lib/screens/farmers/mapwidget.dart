import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapboxMapWidget extends StatefulWidget {
  @override
  _MapboxMapWidgetState createState() => _MapboxMapWidgetState();
}

class _MapboxMapWidgetState extends State<MapboxMapWidget> {
  static const String accessToken =
      "pk.eyJ1IjoiZGtyMTExIiwiYSI6ImNtNHNndnhqcTAwejMyaXM4Y2U1YXQ5YTIifQ.OHgKi3UAORMWIGWGnhtUxg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapbox Map")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-1.286389, 36.817223), // Nairobi, Kenya
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/dkr111/cm4sgyas2001l01sigoiaddyn/tiles/{z}/{x}/{y}?access_token={YOUR_MAPBOX_ACCESS_TOKEN}', // **REPLACE WITH YOUR TOKEN**
          ),
        ],
      ),
    );
  }
}
