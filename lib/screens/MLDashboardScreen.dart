import 'package:flutter/material.dart';
import 'package:ifms/fragments/MLCalendarFragment.dart';
import 'package:ifms/fragments/MLHomeFragment.dart';
import 'package:ifms/fragments/MLNotificationFragment.dart';
import 'package:ifms/fragments/MLProfileFragemnt.dart';
import 'package:ifms/fragments/dashboard.dart';
import 'package:ifms/screens/farmers/farmers.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:ifms/utils/MLCommon.dart';

class MLDashboardScreen extends StatefulWidget {
  static String tag = '/MLDashboardScreen';

  @override
  _MLDashboardScreenState createState() => _MLDashboardScreenState();
}

class _MLDashboardScreenState extends State<MLDashboardScreen> {
  int currentWidget = 0;
  List<Widget> widgets = [
    DashboardScreen(),
    FarmersList(),
    MLNotificationFragment(),
    MLProfileFragment(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // Initialization code
  }

  @override
  void dispose() {
    changeStatusColor(mlPrimaryColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: widgets[currentWidget],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor:
              mlPrimaryColor, // Dark green background for bottom nav
          selectedItemColor: Colors.white, // Ensure selected item is visible
          unselectedItemColor: Colors.white70, // Adjust unselected item color
          type: BottomNavigationBarType.fixed, // Prevents transparency issues
          currentIndex: currentWidget,
          onTap: (index) {
            setState(() {
              currentWidget = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.agriculture),
              label: 'Farmers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
