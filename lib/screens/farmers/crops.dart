import 'package:flutter/material.dart';
import 'package:ifms/api/my_api.dart';
import 'package:ifms/model/crops.dart';
import 'package:ifms/screens/farmers/checklist.dart';
import 'package:ifms/screens/farmers/editfarm.dart';
import 'package:ifms/screens/farmers/mainwidget.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:ifms/api/ApiProvider.dart';

class CropsScreen extends StatefulWidget {
  final int growerId;

  const CropsScreen({
    required this.growerId,
    Key? key,
  }) : super(key: key);

  @override
  _CropsScreenState createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  bool _isLoading = true;
  List<Crop> _crops = [];

  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _varietyController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _populationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCrops();
    });
  }

  Future<void> _fetchCrops() async {
    try {
      final crops = await Provider.of<CropsProvider>(context, listen: false)
          .fetchCrops(widget.growerId);

      setState(() {
        _crops = crops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch crops: $e')),
      );
    }
  }

  void _addCrop() async {
    Fluttertoast.showToast(
      msg: "Please wait ...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Map<String, dynamic> data = {
      'crop': _cropController.text,
      'variety': _varietyController.text,
      'age': _ageController.text,
      'population': _populationController.text,
      'farmer_id': widget.growerId,
    };

    var res = await CallApi().postData(data, 'add-crop');
    print(data);
    if (res['status'] == true) {
      Fluttertoast.showToast(
        msg: "Crop added successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Refresh the data immediately
      _fetchCrops();
      Navigator.pop(context); // Close the modal after adding the crop
    } else {
      Fluttertoast.showToast(
        msg: res['message'] ?? "Failed to add crop",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _showAddCropModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Crop'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _cropController,
                  decoration: const InputDecoration(labelText: 'Crop'),
                ),
                TextField(
                  controller: _varietyController,
                  decoration: const InputDecoration(labelText: 'Variety'),
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                TextField(
                  controller: _populationController,
                  decoration: const InputDecoration(labelText: 'Population'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the modal without action
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _addCrop,
              child: const Text('Add Crop'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCrop(Crop crop) async {
    Fluttertoast.showToast(
      msg: "Deleting crop...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    try {
      Map<String, dynamic> data = {'id': crop.id};
      var res = await CallApi().postData(data, 'delete-crop', id: crop.id);

      if (res['status'] == true) {
        Fluttertoast.showToast(
          msg: "Crop deleted successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Refresh the data immediately
        _fetchCrops();
      } else {
        Fluttertoast.showToast(
          msg: res['message'] ?? "Failed to delete crop",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
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
          'Step 3: Crop Details',
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
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: Column(
          children: [
            // Add Crop Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: _showAddCropModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mlPrimaryColor, // Button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text(
                  'Add Crop',
                  style: TextStyle(color: whiteColor),
                ),
              ),
            ),

            // Check if loading or show data
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _crops.isEmpty
                        ? const Center(
                            child: Text(
                              'No crops available. Please add a crop.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _crops.length,
                            itemBuilder: (context, index) {
                              var crop = _crops[index];
                              return Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Crop Name & Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Crop Name (Bold)
                                            Text(
                                              crop.crop,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            // Variety, Age, Population
                                            Text('Variety: ${crop.variety}',
                                                style: const TextStyle(
                                                    color: Colors.black54)),
                                            Text('Age: ${crop.age}',
                                                style: const TextStyle(
                                                    color: Colors.black54)),
                                            Text(
                                                'Population: ${crop.population}',
                                                style: const TextStyle(
                                                    color: Colors.black54)),
                                          ],
                                        ),
                                      ),
                                      // Delete Button
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _deleteCrop(crop),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
      nextPage: ChecklistScreen(
        growerid: widget.growerId,
      ),
      previousPage: EditFarmScreen(growerid: widget.growerId),
      isStepComplete:
          _crops.isNotEmpty, // Set to true only if there is at least one crop
      step: 3,
    );
  }
}
