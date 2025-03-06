import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:ifms/api/my_api.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:latlong2/latlong.dart';
import 'package:nb_utils/nb_utils.dart';

class MapPolygonScreen extends StatefulWidget {
  final String editingType;
  final int farmerId;
  final LatLng? initialLocation;

  const MapPolygonScreen({
    Key? key,
    required this.editingType,
    required this.farmerId,
    this.initialLocation,
  }) : super(key: key);

  @override
  _MapPolygonScreenState createState() => _MapPolygonScreenState();
}

class _MapPolygonScreenState extends State<MapPolygonScreen> {
  final MapController _mapController = MapController();
  bool _isDrawing = false;
  List<LatLng> _polygonPoints = [];
  late MapController mapController;
  LatLng? _center;
  final LatLng nairobiCenter = LatLng(-1.286389, 36.817223);
  List<LatLng> farmAreaPoints = [];
  List<LatLng> cropAreaPoints = [];
  List<LatLng> conservationPoints = [];
  void _toggleDrawing() {
    setState(() {
      _isDrawing = !_isDrawing;
      if (!_isDrawing) {
        Navigator.pop(context, _polygonPoints);
      }
    });
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (_isDrawing) {
      setState(() {
        _polygonPoints.add(point);
      });
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

  List<Map<String, double>> _getCoordinates() {
    List<LatLng> points = [];
    switch (widget.editingType) {
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

  Future<void> _updateDetails() async {
    Fluttertoast.showToast(
      msg: "Updating details, please wait...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Map<String, dynamic> data = {
      "type": widget.editingType,
      "coordinates": _getCoordinates(),
    };

    var res =
        await CallApi().postData(data, 'savePolygons', id: widget.farmerId);

    if (res['status'] == true) {
      Fluttertoast.showToast(
        msg: "Updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Update failed: ${res['message']}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mlPrimaryColor,
          title: const Text(
            'Draw Polygons',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ],
        ),
        body: Stack(children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialLocation ?? LatLng(0.0, 0.0),
              initialZoom: 15.0,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: _polygonPoints.isNotEmpty
                        ? _polygonPoints
                        : [LatLng(0.0, 0.0)],
                    color: Colors.blue.withOpacity(0.5),
                    borderStrokeWidth: 3,
                    borderColor: Colors.blue,
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
        ]));
  }
}
