import 'package:flutter/material.dart';
import 'package:ifms/main.dart';
import 'package:ifms/screens/farmers/farmers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ifms/components/MLAppointmentDetailListComponent.dart';
import 'package:ifms/components/MLDeliveredDataComponent.dart';
import 'package:ifms/utils/MLColors.dart';

class FarmerFragment extends StatefulWidget {
  static String tag = '/MLFarmerFragment';

  @override
  MLCalendarFragmentState createState() => MLCalendarFragmentState();
}

class MLCalendarFragmentState extends State<FarmerFragment>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mlPrimaryColor,
        body: Column(
          children: [
            Row(
              children: [
                Text('Farmers', style: boldTextStyle(size: 20, color: white))
                    .expand(),
              ],
            ).paddingAll(16.0),
            8.width,
            Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radiusOnly(topRight: 32),
                backgroundColor: appStore.isDarkModeOn ? black : white,
              ),
              child: Column(
                children: [
                  16.height,
                  FarmersList(),
                ],
              ),
            ).expand()
          ],
        ),
      ),
    );
  }
}
