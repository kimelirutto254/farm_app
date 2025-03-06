import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ifms/utils/MLColors.dart'; // Ensure this path is correct

class MapPolygonScreen extends StatefulWidget {
  final String editingType;
  final int farmerId;
  final LatLng? initialLocation; // Accept initial location

  const MapPolygonScreen({
    Key? key,
    required this.editingType,
    required this.farmerId,
    this.initialLocation, // Optional initial location
  }) : super(key: key);

  @override
  _MapPolygonScreenState createState() => _MapPolygonScreenState();
}

class _MapPolygonScreenState extends State<MapPolygonScreen> {
  late MapController mapController;
  List<LatLng> farmAreaPoints = [];
  List<LatLng> cropAreaPoints = [];
  List<LatLng> conservationPoints = [];
  List<LatLng> locationPoints = [];

  final LatLng nairobiCenter = LatLng(-1.286389, 36.817223);
  bool _isDrawing = false;
  LatLng? _center;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _center = widget.initialLocation ??
        nairobiCenter; // Use initial location if provided
    if (widget.editingType == "location") {
      locationPoints = [_center!];
    }
  }

  void _onMapTapped(TapPosition tapPosition, LatLng latLng) {
    if (!_isDrawing && widget.editingType != "location") {
      print("Drawing is disabled");
      return;
    }

    setState(() {
      switch (widget.editingType) {
        case "farm":
          farmAreaPoints.add(latLng);
          break;
        case "crop":
          cropAreaPoints.add(latLng);
          break;
        case "conservation":
          conservationPoints.add(latLng);
          break;
        case "location":
          locationPoints = [latLng];
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location updated!')),
          );
          break;
      }
    });

    print("New point added: $latLng");
  }

  Future<void> _updateDetails() async {
    const String endpoint = "YOUR_ACTUAL_API_ENDPOINT";
    Map<String, dynamic> payload = {
      "type": widget.editingType,
      "coordinates": _getCoordinates(),
    };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      String message = response.statusCode == 200
          ? "Updated successfully!"
          : "Update failed: ${response.statusCode}";
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }
  }

  List<Map<String, double>> _getCoordinates() {
    List<LatLng> points = [];
    switch (widget.editingType) {
      case "location":
        points = locationPoints;
        break;
      case "farm":
        points = farmAreaPoints;
        break;
      case "crop":
        points = cropAreaPoints;
        break;
      case "conservation":
        points = conservationPoints;
        break;
    }
    return points.map((p) => {"lat": p.latitude, "lng": p.longitude}).toList();
  }

  void _toggleDrawing() {
    if (widget.editingType != "location") {
      setState(() => _isDrawing = !_isDrawing);
    }
  }

  void _clearPolygon() => setState(() {
        farmAreaPoints.clear();
        cropAreaPoints.clear();
        conservationPoints.clear();
      });

  void _zoomIn() => mapController.move(_center!, mapController.camera.zoom + 1);
  void _zoomOut() =>
      mapController.move(_center!, mapController.camera.zoom - 1);
  void _centerOnLocation() {
    setState(() => _center = widget.initialLocation ?? nairobiCenter);
    mapController.move(_center!, mapController.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture ${widget.editingType} Polygons')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: widget.initialLocation!,
              initialZoom: 12,
              onTap: _onMapTapped,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZGtyMTExIiwiYSI6ImNtNHNndnhqcTAwejMyaXM4Y2U1YXQ5YTIifQ.OHgKi3UAORMWIGWGnhtUxg',
                additionalOptions: {
                  'access_token':
                      'pk.eyJ1IjoiZGtyMTExIiwiYSI6ImNtNHNndnhqcTAwejMyaXM4Y2U1YXQ5YTIifQ.OHgKi3UAORMWIGWGnhtUxg',
                },
              ),
              PolygonLayer(
                polygons: [
                  if (farmAreaPoints.isNotEmpty)
                    _buildPolygon(
                        farmAreaPoints, Colors.green.withOpacity(0.5)),
                  if (cropAreaPoints.isNotEmpty)
                    _buildPolygon(cropAreaPoints, Colors.blue.withOpacity(0.5)),
                  if (conservationPoints.isNotEmpty)
                    _buildPolygon(
                        conservationPoints, Colors.red.withOpacity(0.5)),
                  if (locationPoints.isNotEmpty)
                    _buildPolygon(
                        locationPoints, Colors.orange.withOpacity(0.3)),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.initialLocation!,
                    child: Column(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        const Text(
                          "Farmer Location",
                          style: TextStyle(fontSize: 1, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              children: [
                if (widget.editingType != "location") // Hide when location
                  FloatingActionButton(
                    onPressed: _toggleDrawing,
                    child: Icon(_isDrawing ? Icons.stop : Icons.edit),
                    mini: true,
                  ),
                FloatingActionButton(
                  onPressed: _clearPolygon,
                  child: const Icon(Icons.clear_all),
                  mini: true,
                ),
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: const Icon(Icons.zoom_in),
                  mini: true,
                ),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: const Icon(Icons.zoom_out),
                  mini: true,
                ),
                FloatingActionButton(
                  onPressed: _centerOnLocation,
                  child: const Icon(Icons.my_location),
                  mini: true,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: _updateDetails,
              label: const Text("Update Details"),
              backgroundColor: mlPrimaryColor,
            ),
          ),
          if (widget.editingType == "location" && !_isDrawing)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.black54,
                child: const Text(
                  'Tap on the map to set the location',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Polygon _buildPolygon(List<LatLng> points, Color color) {
    return Polygon(
      points: points,
      color: color,
      borderColor: color.withOpacity(0.8),
      borderStrokeWidth: 2,
    );
  }
}
