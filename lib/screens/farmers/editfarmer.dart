import 'package:flutter/material.dart';
import 'package:ifms/api/ApiProvider.dart';
import 'package:ifms/api/my_api.dart';
import 'package:ifms/model/farmers.dart';
import 'package:ifms/screens/farmers/editfarm.dart';
import 'package:ifms/screens/farmers/farmers.dart';
import 'package:ifms/screens/farmers/mainwidget.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class EditFarmerScreen extends StatefulWidget {
  final int growerid;

  EditFarmerScreen({required this.growerid});

  @override
  _EditFarmerScreenState createState() => _EditFarmerScreenState();
}

class _EditFarmerScreenState extends State<EditFarmerScreen> {
  late TextEditingController _dobController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _farmSizeController;
  late TextEditingController _productionAreaController;
  late TextEditingController _temporaryMaleWorkersController;
  late TextEditingController _temporaryFemaleWorkersController;
  late TextEditingController _genderController;

  bool _isLoading = true;
  bool _isStepComplete = false;
  Farmer? _farmer;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _farmSizeController = TextEditingController();
    _productionAreaController = TextEditingController();
    _temporaryMaleWorkersController = TextEditingController();
    _temporaryFemaleWorkersController = TextEditingController();
    _genderController = TextEditingController();

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
          _dobController.text = farmer.dob ?? '';
          _phoneNumberController.text = farmer.phoneNumber ?? '';
          _farmSizeController.text = farmer.farmSize ?? '';
          _productionAreaController.text = farmer.productionArea ?? '';
          _temporaryMaleWorkersController.text =
              farmer.temporaryMaleWorkers ?? '';
          _temporaryFemaleWorkersController.text =
              farmer.temporaryFemaleWorkers ?? '';
          _genderController.text = farmer.gender ?? '';
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

  Future<void> _updateFarmer() async {
    if (_dobController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _farmSizeController.text.isEmpty ||
        _productionAreaController.text.isEmpty ||
        _temporaryMaleWorkersController.text.isEmpty ||
        _temporaryFemaleWorkersController.text.isEmpty ||
        _genderController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all required fields!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() => _isStepComplete = false);
    }

    Fluttertoast.showToast(
      msg: "Please wait ...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    print(_genderController.text);
    Map<String, dynamic> data = {
      'dob': _dobController.text,
      'phone_number': _phoneNumberController.text,
      'farm_size': _farmSizeController.text,
      'production_area': _productionAreaController.text,
      'temporary_male_workers': _temporaryMaleWorkersController.text,
      'temporary_female_workers': _temporaryFemaleWorkersController.text,
      'gender': _genderController.text,
    };

    var res =
        await CallApi().postData(data, 'update-farmer', id: widget.growerid);
    if (res['status'] == true) {
      setState(() => _isStepComplete = true);
      Fluttertoast.showToast(
        msg: "Farmer details updated successfully!",
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
  void dispose() {
    _dobController.dispose();
    _phoneNumberController.dispose();
    _farmSizeController.dispose();
    _productionAreaController.dispose();
    _temporaryMaleWorkersController.dispose();
    _temporaryFemaleWorkersController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultistepWidget(
      appBar: AppBar(
        backgroundColor: mlPrimaryColor,
        title: const Text(
          'Step 1: Farmer Details',
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
                  _buildTextField('Date of Birth', _dobController,
                      isDate: true),
                  _buildDropdownField(
                      'Gender', _genderController, ['male', 'female', 'other']),
                  _buildTextField('Phone Number', _phoneNumberController,
                      isPhone: true),
                  _buildTextField('Farm Size', _farmSizeController),
                  _buildTextField('Production Area', _productionAreaController),
                  _buildTextField(
                      'Temporary Male Workers', _temporaryMaleWorkersController,
                      isNumber: true),
                  _buildTextField('Temporary Female Workers',
                      _temporaryFemaleWorkersController,
                      isNumber: true),
                  ElevatedButton(
                    onPressed: _updateFarmer,
                    child: Text('Update Farmer Details'),
                  ),
                ],
              ),
            ),
      nextPage: EditFarmScreen(
        growerid: widget.growerid,
      ),
      previousPage: FarmersList(),
      isStepComplete: _farmer != null,
      step: 1,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isDate = false, bool isPhone = false, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: isDate
            ? TextInputType.datetime
            : isPhone
                ? TextInputType.phone
                : isNumber
                    ? TextInputType.number
                    : TextInputType.text,
      ),
    );
  }

  Widget _buildDropdownField(
      String label, TextEditingController controller, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: options.contains(controller.text.toLowerCase())
            ? controller.text.toLowerCase()
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            controller.text = newValue!;
          });
        },
      ),
    );
  }
}
