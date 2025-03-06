import 'package:flutter/material.dart';
import 'package:ifms/api/ApiProvider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ifms/model/MLNotificationData.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:ifms/utils/MLDataProvider.dart';
import 'package:ifms/utils/MLString.dart';
import 'package:ifms/main.dart';
import 'package:provider/provider.dart'; // Importing provider package

class MLNotificationFragment extends StatefulWidget {
  static String tag = '/MLNotificationFragment';

  @override
  MLNotificationFragmentState createState() => MLNotificationFragmentState();
}

class MLNotificationFragmentState extends State<MLNotificationFragment> {
  List<MLNotificationData> data = mlNotificationDataList();
  bool checked = false;
  int? newNotification = 3;
  Color customColor = mlColorBlue;
  bool valuefirst = false;
  bool valuesecond = false;

  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<NotificationsProvider>(context, listen: false)
          .fetchnotifications();
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
    final notificationsProvider = Provider.of<NotificationsProvider>(context);
    final notifications =
        notificationsProvider.notifications; // List from provider

    return SafeArea(
      child: Scaffold(
        backgroundColor: mlPrimaryColor,
        body: Container(
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: radiusOnly(topRight: 32),
            backgroundColor: appStore.isDarkModeOn ? black : white,
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Notifications', style: boldTextStyle(size: 20)),
                      8.width,
                    ],
                  ).expand(),
                ],
              ).paddingAll(16.0),

              8.height,

              // Notifications List
              Expanded(
                child: notifications.isNotEmpty
                    ? ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return ListTile(
                            leading:
                                Icon(Icons.notifications, color: mlColorBlue),
                            title: Text(notification.notification,
                                style: primaryTextStyle()),
                            subtitle: Text(notification.createdAt.toString(),
                                style: secondaryTextStyle()),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey),
                            onTap: () {
                              // Handle notification tap
                            },
                          ).paddingSymmetric(vertical: 4, horizontal: 16);
                        },
                      )
                    : Center(
                        child: Text("No notifications",
                            style: secondaryTextStyle()),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
