import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ifms/api/ApiProvider.dart';
import 'package:ifms/api/my_api.dart';
import 'package:ifms/screens/farmers/crops.dart';
import 'package:ifms/screens/farmers/location.dart';
import 'package:ifms/screens/farmers/mainwidget.dart';
import 'package:ifms/screens/farmers/mapstep.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ChecklistScreen extends StatefulWidget {
  final int growerid;

  const ChecklistScreen({Key? key, required this.growerid}) : super(key: key);

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  int _currentStep = 0;
  final Map<String, String> responses = {};
  final Map<String, String> followupDetails = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChecklistProvider>(context, listen: false).fetchchecklist();
    });
  }

  void _submitInspection() async {
    Fluttertoast.showToast(
      msg: "Submitting inspection...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Map<String, dynamic> data = {
      'farmer_id': widget.growerid,
      'responses': responses,
      'non_conformities': followupDetails,
    };

    var res = await CallApi().postData(data, 'inspections/save');

    if (res['status'] == true) {
      Fluttertoast.showToast(
        msg: "Inspection submitted successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationScreen(farmerId: widget.growerid),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: res['message'] ?? "Submission failed.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _showFollowUpDialog(String key) {
    TextEditingController followupController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Follow-up Details"),
          content: TextField(
            controller: followupController,
            decoration:
                const InputDecoration(hintText: "Enter follow-up details"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  followupDetails[key] = followupController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final inspectionProvider = Provider.of<ChecklistProvider>(context);

    if (inspectionProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (inspectionProvider.checklist.isEmpty) {
      return const Center(child: Text("No checklist data available."));
    }

    return MultistepWidget(
      appBar: AppBar(
        backgroundColor: mlPrimaryColor,
        title: const Text(
          'Step 4: Checklist',
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
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (responses.containsKey(
              inspectionProvider.checklist[_currentStep].requirementCode)) {
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text("Please answer the question before proceeding.")),
            );
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        steps: inspectionProvider.checklist.map((checklist) {
          return Step(
            title: Text(checklist.chapter,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(checklist.subchapter,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(checklist.requirement),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Yes', 'No', 'N/A'].map((option) {
                    return Expanded(
                      child: RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: responses[checklist.requirementCode],
                        onChanged: (value) {
                          setState(() {
                            responses[checklist.requirementCode] = value!;
                          });
                          if (value == 'No') {
                            _showFollowUpDialog(checklist.requirementCode);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
                if (responses[checklist.requirementCode] == 'No' &&
                    followupDetails.containsKey(checklist.requirementCode))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Follow-up: ${followupDetails[checklist.requirementCode]}",
                      style: const TextStyle(
                          color: Colors.red, fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
      nextPage: LocationScreen(farmerId: widget.growerid),
      previousPage: CropsScreen(growerId: widget.growerid),
      isStepComplete: true,
      step: 4,
    );
  }
}
