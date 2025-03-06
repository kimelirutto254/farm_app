import 'package:flutter/material.dart';
import 'package:ifms/utils/MLColors.dart';

class MultistepWidget extends StatelessWidget {
  final Widget appBar;
  final Widget body;
  final Widget nextPage;
  final Widget previousPage;
  final bool isStepComplete;
  final double step;

  const MultistepWidget({
    required this.appBar,
    required this.body,
    required this.nextPage,
    required this.previousPage,
    required this.isStepComplete,
    required this.step,
    Key? key,
  }) : super(key: key);

  void _goToNextPage(BuildContext context) {
    if (isStepComplete) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete this step before proceeding")),
      );
    }
  }

  void _goToPreviousPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => previousPage),
    );
  }

  void _close(BuildContext context) {
    Navigator.pop(context); // Closes the current screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          color: Colors.blue, // Set your desired background color
          child: Stack(
            children: [
              appBar, // Original app bar
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: body), // Ensures body takes up available space
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _goToPreviousPage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        mlPrimaryColor, // Match the Add Crop button color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child:
                      const Text("Back", style: TextStyle(color: Colors.white)),
                ),
                Text(
                  "Step ${step.toInt()} of 7",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // Conditionally hide the "Next" button on step 7
                if (step < 7)
                  ElevatedButton(
                    onPressed: () => _goToNextPage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          mlPrimaryColor, // Match the Add Crop button color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text("Next",
                        style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
