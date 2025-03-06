import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'package:ifms/screens/farmers/mainwidget.dart';
import 'package:ifms/screens/farmers/mapstep.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:latlong2/latlong.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:signature/signature.dart';
import 'dart:io'; // For File

class CompleteScreen extends StatefulWidget {
  final int farmerId;
  const CompleteScreen({
    required this.farmerId,
    Key? key,
  }) : super(key: key);

  @override
  _CompleteScreenState createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  final SignatureController _signatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 5,
    exportBackgroundColor: Colors.transparent,
  );

  File? _uploadedImage; // Variable to store the uploaded image

  // Method to pick the image from camera or gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await showDialog<XFile>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context)
                    .pop(await picker.pickImage(source: ImageSource.camera));
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context)
                    .pop(await picker.pickImage(source: ImageSource.gallery));
              },
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
    if (pickedFile != null) {
      setState(() {
        _uploadedImage = File(pickedFile.path); // Convert XFile to File
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultistepWidget(
      appBar: AppBar(
        backgroundColor: mlPrimaryColor,
        title: const Text(
          'Step 7: Signature',
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
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upload Farmer ID Card',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _pickImage, // Pick image when pressed
                  child: const Text('Upload ID Card'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_uploadedImage != null)
                  Column(
                    children: [
                      Image.file(
                        _uploadedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                const Text(
                  'Sign Here:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Signature(
                  controller: _signatureController,
                  height: 200,
                  backgroundColor: Colors.grey[200]!,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _signatureController.clear();
                        });
                      },
                      child: const Text('Clear'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          // Centered small button with text
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission here
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 14, // Smaller font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Submit Inspection'),
              ),
            ),
          ),
        ],
      ),
      nextPage: Container(),
      previousPage: MapStep(
        farmerId: widget.farmerId,
        farmerLocation: LatLng(0, 0),
      ),
      isStepComplete: true,
      step: 7,
    );
  }
}
