import 'package:flutter/material.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:nb_utils/nb_utils.dart';

class MLProfileFragment extends StatelessWidget {
  static String tag = '/MLProfileFragment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mlPrimaryColor,
        title: Text('Profile', style: boldTextStyle(color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false, // Hide back icon
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            12.height,
            Text('Dismas', style: boldTextStyle(size: 20)),
            Text('dc@gmail.com', style: secondaryTextStyle()),
            8.height,
            Text('Version 1.0.0',
                style: secondaryTextStyle(size: 12, color: Colors.grey)),
            24.height,
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Handle logout action
              },
              icon: Icon(Icons.logout, color: Colors.white),
              label: Text('Logout', style: boldTextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
