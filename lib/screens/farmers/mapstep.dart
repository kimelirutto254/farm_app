import 'package:flutter/material.dart';
import 'package:ifms/screens/farmers/checklist.dart';
import 'package:ifms/screens/farmers/complete.dart';
import 'package:ifms/screens/farmers/mainwidget.dart';
import 'package:ifms/screens/farmers/mapscreen.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:latlong2/latlong.dart';
import 'package:nb_utils/nb_utils.dart';

class MapStep extends StatelessWidget {
  final int farmerId;
  final LatLng farmerLocation;
  final Map<String, bool> updateStatus;

  const MapStep({
    required this.farmerId,
    required this.farmerLocation,
    this.updateStatus = const {},
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultistepWidget(
      appBar: AppBar(
        backgroundColor: mlPrimaryColor,
        title: const Text(
          'Step 6: GPS Coordinate',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMapButton(context, 'Farm Area', mlColorDarkBlue, 'farm_area'),
          _buildMapButton(context, 'Crop Area', mlPrimaryColor, 'crop_area'),
          _buildMapButton(context, 'Conservation Area', mlPrimaryColor,
              'conservation_area'),
          _buildMapButton(context, 'Sketch Map', mlPrimaryColor, 'sketch_map'),
        ],
      ),
      nextPage: CompleteScreen(farmerId: farmerId),
      previousPage: ChecklistScreen(growerid: farmerId),
      isStepComplete: true,
      step: 6,
    );
  }

  Widget _buildMapButton(
      BuildContext context, String title, Color color, String type) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: boldTextStyle(color: Colors.white, size: 14),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await MapPolygonScreen(
                    editingType: type,
                    farmerId: farmerId,
                    initialLocation: farmerLocation,
                  ).launch(context);
                  // This is mutable since it's passed as a reference
                  updateStatus[type] = true;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                child: Text(
                  'Capture Polygon',
                  style: boldTextStyle(color: color, size: 12),
                ),
              ),
              if (updateStatus[type] == true)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check_circle, color: Colors.green),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
