import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ifms/api/ApiProvider.dart';
import 'package:ifms/api/my_api.dart';
import 'package:ifms/model/farmers.dart';
import 'package:ifms/screens/farmers/crops.dart';
import 'package:ifms/screens/farmers/editfarmer.dart';
import 'package:ifms/screens/farmers/mainwidget.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditFarmScreen extends StatefulWidget {
  final int growerid;

  EditFarmScreen({required this.growerid});

  @override
  _EditFarmScreenState createState() => _EditFarmScreenState();
}

class _EditFarmScreenState extends State<EditFarmScreen> {
  late TextEditingController _regionController;
  late TextEditingController _townController;
  late TextEditingController _routeController;
  late TextEditingController _buyingCenterController;
  late TextEditingController _conservationAreaController;
  late TextEditingController _residentialAreaController;
  late TextEditingController _otherCropsAreaController;
  late TextEditingController _leasedAreaController;
  late TextEditingController _productionAreaController;
  late TextEditingController _farmAreaController;

  bool _isLoading = true;
  Farmer? _farmer;
  bool _isStepComplete = false;

  @override
  void initState() {
    super.initState();
    _regionController = TextEditingController();
    _townController = TextEditingController();
    _routeController = TextEditingController();
    _buyingCenterController = TextEditingController();
    _conservationAreaController = TextEditingController();
    _residentialAreaController = TextEditingController();
    _otherCropsAreaController = TextEditingController();
    _leasedAreaController = TextEditingController();
    _productionAreaController = TextEditingController();
    _farmAreaController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFarmerData();
    });
  }

  Future<void> _fetchFarmerData() async {
    try {
      final farmer =
          await Provider.of<FarmerViewProvider>(context, listen: false)
              .fetchfarmer(widget.growerid);

      if (farmer != null) {
        setState(() {
          _farmer = farmer;
          _regionController.text = farmer.region ?? '';
          _townController.text = farmer.town ?? '';
          _routeController.text = farmer.route ?? '';
          _buyingCenterController.text = farmer.buyingCenter ?? '';
          _conservationAreaController.text = farmer.conservationArea ?? '';
          _residentialAreaController.text = farmer.residentialArea ?? '';
          _otherCropsAreaController.text = farmer.otherCropsArea ?? '';
          _leasedAreaController.text = farmer.leased ?? '';
          _productionAreaController.text = farmer.productionArea ?? '';
          _farmAreaController.text = farmer.farmSize ?? '';
          _isStepComplete = true;
        });
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch farmer data: $e')),
      );
    }
  }

  Future<void> _updateFarmDetails() async {
    if (_townController.text.isEmpty ||
        _routeController.text.isEmpty ||
        _buyingCenterController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all required fields!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() => _isStepComplete = false);
      return;
    }

    Fluttertoast.showToast(
      msg: "Please wait ...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Map<String, dynamic> data = {
      'region': _regionController.text,
      'town': _townController.text,
      'route': _routeController.text,
      'buying_center': _buyingCenterController.text,
      'conservation_area': _conservationAreaController.text,
      'residential_area': _residentialAreaController.text,
      'other_crops_area': _otherCropsAreaController.text,
      'leased': _leasedAreaController.text,
    };

    var res =
        await CallApi().postData(data, 'update-farm', id: widget.growerid);
    if (res['status'] == true) {
      setState(() => _isStepComplete = true);
      Fluttertoast.showToast(
        msg: "Farm details updated successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      setState(() => _isStepComplete = false);
      Fluttertoast.showToast(
        msg: res['message'],
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
    return MultistepWidget(
      appBar: AppBar(
        backgroundColor: mlPrimaryColor,
        title: const Text(
          'Step 2: Farm Details',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Close',
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildTextField('Region', _regionController),
                  _buildTextField('Town', _townController),
                  _buildTextField('Route', _routeController),
                  _buildTextField('Buying Center', _buyingCenterController),
                  _buildTextField(
                      'Conservation Area', _conservationAreaController),
                  _buildTextField(
                      'Residential Area', _residentialAreaController),
                  _buildTextField(
                      'Other Crops Area', _otherCropsAreaController),
                  _buildTextField('Leased Area', _leasedAreaController),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateFarmDetails,
                    child: Text("Update Farm Details"),
                  ),
                ],
              ),
            ),
      nextPage: CropsScreen(growerId: widget.growerid),
      previousPage: EditFarmerScreen(growerid: widget.growerid),
      isStepComplete: _isStepComplete,
      step: 2,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
