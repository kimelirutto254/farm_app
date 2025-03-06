import 'package:flutter/material.dart';
import 'package:ifms/api/ApiProvider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:ifms/utils/MLCommon.dart';
import 'package:provider/provider.dart'; // Importing provider package
import 'package:ifms/main.dart';

class FarmerViewScreen extends StatefulWidget {
  static String tag = '/FarmerViewScreen';
  final int grower_id;

  const FarmerViewScreen({Key? key, required this.grower_id}) : super(key: key);

  @override
  FarmerViewScreenState createState() => FarmerViewScreenState();
}

class FarmerViewScreenState extends State<FarmerViewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<FarmerViewProvider>(context, listen: false)
          .fetchfarmer(widget.grower_id);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final farmerProvider = Provider.of<FarmerViewProvider>(context);
    final farmer = farmerProvider.farmer; // Single farmer (not a list)

    return SafeArea(
      child: Scaffold(
        backgroundColor: mlPrimaryColor,
        body: Container(
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: radiusOnly(topRight: 32),
            backgroundColor: appStore.isDarkModeOn ? black : white,
          ),
          child: farmerProvider.isLoading
              ? Center(child: CircularProgressIndicator()) // Loading state
              : farmer == null
                  ? Center(child: Text('No Farmer Data Available'))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          8.height,
                          Row(
                            children: [
                              mlBackToPreviousWidget(context,
                                  appStore.isDarkModeOn ? white : blackColor),
                              Text('Farmer Details',
                                  style: boldTextStyle(size: 22)),
                            ],
                          ).paddingAll(16),

                          // Farmer Details View
                          Container(
                            margin: EdgeInsets.only(bottom: 80),
                            padding: EdgeInsets.all(12.0),
                            decoration: boxDecorationWithRoundedCorners(
                              border: Border.all(color: mlColorLightGrey),
                              borderRadius: radius(12),
                              backgroundColor: context.cardColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                16.height,
                                Text('Farmer Information',
                                    style: boldTextStyle(size: 18)),
                                16.height,

                                // Farmer Name
                                Row(
                                  children: [
                                    Icon(Icons.person, color: mlPrimaryColor),
                                    8.width,
                                    Text(
                                      '${farmer.firstName} ${farmer.lastName}',
                                      style: boldTextStyle(size: 18),
                                    ),
                                  ],
                                ),
                                16.height,

                                // Farmer Location
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        color: mlPrimaryColor),
                                    8.width,
                                    Text(
                                      'Location: ${farmer.town ?? 'No location'}',
                                      style: primaryTextStyle(),
                                    ),
                                  ],
                                ),
                                16.height,

                                // Buying Center
                                Row(
                                  children: [
                                    Icon(Icons.store, color: mlPrimaryColor),
                                    8.width,
                                    Text(
                                      'Buying Center: ${farmer.buyingCenter ?? 'No Buying Center'}',
                                      style: primaryTextStyle(),
                                    ),
                                  ],
                                ),
                                16.height,

                                // Route
                                Row(
                                  children: [
                                    Icon(Icons.route, color: mlPrimaryColor),
                                    8.width,
                                    Text(
                                      'Route: ${farmer.route ?? 'No route info'}',
                                      style: primaryTextStyle(),
                                    ),
                                  ],
                                ),
                                16.height,

                                // Inspection Status
                                Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: mlPrimaryColor),
                                    8.width,
                                    Text(
                                      'Inspection Status: ${farmer.inspectionStatus ?? 'Not Available'}',
                                      style: primaryTextStyle(),
                                    ),
                                  ],
                                ),
                                16.height,

                                Divider(thickness: 0.5),
                                16.height,

                                // View Details Button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('View Details',
                                        style: boldTextStyle(size: 16)),
                                    Icon(Icons.arrow_forward,
                                        color: mlPrimaryColor, size: 20),
                                  ],
                                ).onTap(() {
                                  // Handle View Details Click
                                  print('View Details Clicked');
                                }),
                              ],
                            ),
                          ).paddingAll(16.0),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
