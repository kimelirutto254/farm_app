import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ifms/api/my_api.dart';
import 'package:ifms/screens/farmers/checklist.dart';
import 'package:ifms/screens/farmers/mainwidget.dart';
import 'package:ifms/screens/farmers/mapstep.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

class LocationScreen extends StatefulWidget {
  final int farmerId;

  const LocationScreen({
    Key? key,
    required this.farmerId,
  }) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late MapController mapController;
  LatLng? selectedLocation;
  final LatLng nairobiCenter = LatLng(-1.286389, 36.817223);
  LatLng? _center;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    selectedLocation = nairobiCenter;
  }

  void _onMapTapped(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      selectedLocation = latLng;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Farmer Location: ${latLng.latitude}, ${latLng.longitude}!')),
    );
  }

  Future<void> _updateLocation() async {
    Fluttertoast.showToast(
      msg: "Updating location, please wait...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Map<String, dynamic> data = {
      "farmerId": widget.farmerId,
      "latitude": selectedLocation?.latitude,
      "longitude": selectedLocation?.longitude,
    };

    var res = await CallApi().postData(data, 'savePoint', id: widget.farmerId);

    if (res['status'] == true) {
      Fluttertoast.showToast(
        msg: "Location updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: res['message'] ?? "Failed to update location",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _zoomIn() => mapController.move(_center!, mapController.camera.zoom + 1);
  void _zoomOut() =>
      mapController.move(_center!, mapController.camera.zoom - 1);
  void _centerOnLocation() {
    setState(() => _center = nairobiCenter);
    mapController.move(nairobiCenter, mapController.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return MultistepWidget(
      appBar: AppBar(
        backgroundColor: mlPrimaryColor,
        title: const Text(
          'Step 5: GPS Coordinate',
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
                  color: whiteColor, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: nairobiCenter,
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
              if (selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation!,
                      child: const Icon(Icons.location_on,
                          color: Colors.red,
                          size: 40), // 📍 Standard location pin
                    ),
                  ],
                ),
            ],
          ),
          // Floating action buttons on the right
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _zoomIn,
                  child: const Icon(Icons.zoom_in),
                  mini: true,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _zoomOut,
                  child: const Icon(Icons.zoom_out),
                  mini: true,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _centerOnLocation,
                  child: const Icon(Icons.explore,
                      color: Colors.white), // 🧭 WhatsApp-style compass
                  mini: true,
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
          ),
          // Floating update button at bottom center
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.5 - 90, // Centered
            child: FloatingActionButton.extended(
              onPressed: _updateLocation,
              label: const Text("Save Farmer Location"),
            ),
          ),
        ],
      ),
      nextPage: MapStep(
        farmerId: widget.farmerId,
        farmerLocation: selectedLocation!,
      ),
      previousPage: ChecklistScreen(growerid: widget.farmerId),
      isStepComplete: selectedLocation != null,
      step: 5,
    );
  }
}
