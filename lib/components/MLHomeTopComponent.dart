import 'package:flutter/material.dart';
import 'package:ifms/fragments/MLCalendarFragment.dart';
import 'package:ifms/fragments/MLNotificationFragment.dart';
import 'package:ifms/screens/MLVideoCounsultScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ifms/model/MLServiceData.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:ifms/utils/MLImage.dart';
import 'package:ifms/utils/MLString.dart';

class MLHomeTopComponent extends StatefulWidget {
  static String tag = '/MLHomeTopComponent';

  @override
  _MLHomeTopComponentState createState() => _MLHomeTopComponentState();
}

class _MLHomeTopComponentState extends State<MLHomeTopComponent> {
  int counter = 2;

  // Method to return the list of services
  List<MLServicesData> mlServiceDataList() {
    List<MLServicesData> data = [];

    data.add(MLServicesData(
        title: 'All Farmers',
        icon: Icons.home,
        image: ml_ic_dashHomeVisit,
        widget: FarmerFragment()));
    data.add(MLServicesData(
        title: 'Recent Inspections',
        icon: Icons.video_call,
        image: ml_ic_dashVideoCons,
        widget: MLVideoConsultScreen()));

    return data;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // Initialize necessary data here if needed
  }

  @override
  Widget build(BuildContext context) {
    // Get the list of services
    List<MLServicesData> data = mlServiceDataList();

    return Container(
      width: context.width(),
      color: mlPrimaryColor,
      margin: EdgeInsets.only(bottom: 1.0),
      child: Column(
        children: [
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      child: Image.asset(
                          ml_ic_profile_picture ?? ''), // Handle null image
                      radius: 22,
                      backgroundColor: black),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello' ?? 'Name', // Handle null profile name
                          style: boldTextStyle(color: whiteColor)),
                      4.height,
                      Text(mlWelcome ?? 'Welcome', // Handle null welcome text
                          style: secondaryTextStyle(
                              color: white.withOpacity(0.7))),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      Icon(Icons.notifications_active, color: white, size: 24),
                    ],
                  ).onTap(() {
                    MLNotificationFragment().launch(context);
                  }),
                ],
              )
            ],
          ).paddingOnly(right: 11.0, left: 16.0),

          // Added space between the containers using SizedBox
          SizedBox(height: 16), // Add space here

          Container(
            margin: EdgeInsets.only(right: 16.0, left: 16.0),
            transform: Matrix4.translationValues(0, 1.0, 0),
            alignment: Alignment.center,
            decoration: boxDecorationRoundedWithShadow(5,
                backgroundColor: context.cardColor),
            child: Column(
              children: [
                16.height,
                // Inspection Statistics Title
                Text(
                  'Inspection Statistics',
                  style: boldTextStyle(color: black, size: 16),
                  textAlign: TextAlign.center,
                ),
                16.height,
                // Stats Section Inside the Container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total Inspections
                      Expanded(
                        child: Column(
                          children: [
                            Text('Total', style: boldTextStyle(color: black)),
                            4.height,
                            Text('0', style: boldTextStyle(color: black)),
                          ],
                        ),
                      ),
                      // Approved Inspections
                      Expanded(
                        child: Column(
                          children: [
                            Text('Approved',
                                style: boldTextStyle(color: black)),
                            4.height,
                            Text('0', style: boldTextStyle(color: black)),
                          ],
                        ),
                      ),
                      // Rejected Inspections
                      Expanded(
                        child: Column(
                          children: [
                            Text('Rejected',
                                style: boldTextStyle(color: black)),
                            4.height,
                            Text('0', style: boldTextStyle(color: black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
