import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:ifms/main.dart';
import 'package:ifms/model/MLProfileCardData.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:ifms/utils/MLDataProvider.dart';
import 'package:nb_utils/nb_utils.dart';

class MLProfileBottomComponent extends StatefulWidget {
  static String tag = '/MLProfileBottomComponent';

  @override
  MLProfileBottomComponentState createState() =>
      MLProfileBottomComponentState();
}

class MLProfileBottomComponentState extends State<MLProfileBottomComponent> {
  List<String> data = <String>[
    'Membership card',
    'Dependents',
    'Health care',
    'Refer friends and family'
  ];
  List<String> categoriesData = <String>[
    'Prescription',
    'Medical Record',
    'Medical Test',
    'Health Tracking'
  ];
  List<Color> customColor = <Color>[
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.cyan
  ];
  List<MLProfileCardData> mlProfileData = mlProfileDataList();

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radiusOnly(topRight: 32),
        backgroundColor: appStore.isDarkModeOn ? blackColor : white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Main Categories', style: boldTextStyle(size: 18)),
              Text('04', style: secondaryTextStyle(size: 16)),
            ],
          ),
          16.height,
          Container(
            // margin: EdgeInsets.only(bottom: 16.0),
            padding: EdgeInsets.all(8.0),
            decoration: boxDecorationRoundedWithShadow(8,
                backgroundColor: context.cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/ic_theme.png',
                            height: 24, width: 24, color: Colors.blue)
                        .paddingOnly(left: 4),
                    8.width,
                    Text('DarkMode', style: primaryTextStyle()),
                  ],
                ),
                Switch(
                  value: appStore.isDarkModeOn,
                  activeColor: Colors.green[900],
                  onChanged: (s) {
                    appStore.toggleDarkMode(value: s);
                  },
                )
              ],
            ),
          ).onTap(
            () {
              appStore.toggleDarkMode();
            },
          ),
          16.height,
        ],
      ),
    );
  }
}
