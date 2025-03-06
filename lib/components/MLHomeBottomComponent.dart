import 'package:flutter/material.dart';
import 'package:ifms/api/ApiProvider.dart';
import 'package:ifms/main.dart';
import 'package:ifms/screens/farmers/editfarmer.dart';
import 'package:ifms/screens/farmers/farmerview.dart';
import 'package:ifms/screens/farmers/mapscreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ifms/model/MLDepartmentData.dart';
import 'package:ifms/model/MLTopHospitalData.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:ifms/utils/MLDataProvider.dart';
import 'package:ifms/utils/MLString.dart';
import 'package:provider/provider.dart'; // Importing provider package

class MLHomeBottomComponent extends StatefulWidget {
  static String tag = '/MLHomeBottomComponent';

  @override
  MLHomeBottomComponentState createState() => MLHomeBottomComponentState();
}

class MLHomeBottomComponentState extends State<MLHomeBottomComponent> {
  List<MLDepartmentData> departmentList = mlDepartmentDataList();

  List<MLTopHospitalData> tophospitalList = mlTopHospitalDataList();

  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<RecentInspectionsProvider>(context, listen: false)
          .fetchrecentinspections();
    });
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final farmers = Provider.of<RecentInspectionsProvider>(context);

    return Column(
      children: [
        8.height,
        Row(
          children: [
            Text('Recent Inspections', style: boldTextStyle(size: 18)).expand(),
            4.width,
          ],
        ).paddingOnly(left: 16, right: 16),
        10.height,
        Column(
          children: farmers.farmers.map(
            (farmer) {
              return Container(
                margin: EdgeInsets.only(top: 8.0),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: appStore.isDarkModeOn
                      ? scaffoldDarkColor
                      : Colors.grey.shade200,
                  borderRadius: radius(12),
                ),
                child: Column(
                  children: [
                    20.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${farmer.firstName} ${farmer.lastName}', // Full name
                                style: boldTextStyle(size: 18)),
                            8.height,
                            Text(
                                'Buying Center: ${farmer.buyingCenter ?? 'No location'}',
                                style: secondaryTextStyle()),
                            8.height,
                            Text('Route: ${farmer.route}',
                                style: secondaryTextStyle()),
                          ],
                        ).expand(),
                      ],
                    ).paddingOnly(right: 16.0, left: 16.0),
                    8.height,

                    8.height,

                    // Status row
                    Row(
                      children: [
                        Text('${farmer.inspectionStatus ?? 'Not Available'}',
                            style: boldTextStyle(color: mlColorDarkBlue)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('View Farmer',
                                style:
                                    secondaryTextStyle(color: mlColorDarkBlue)),
                            4.width,
                            Icon(Icons.arrow_forward,
                                color: mlPrimaryColor, size: 16),
                          ],
                        ).onTap(
                          () {
                            // Navigate to a details screen (if available)
                            FarmerViewScreen(
                              grower_id: farmer.growerId.toInt(),
                            ).launch(context);
                          },
                        ).expand()
                      ],
                    ).paddingOnly(right: 16.0, left: 16.0),
                    Divider(thickness: 0.5),

                    // New buttons row
                  ],
                ),
              ).paddingBottom(16.0);
            },
          ).toList(),
        ),
      ],
    );
  }
}
