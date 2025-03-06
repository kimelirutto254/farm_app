import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ifms/fragments/dashboard.dart';

class MLHomeFragment extends StatefulWidget {
  static String tag = '/MLHomeFragment';

  @override
  _MLHomeFragmentState createState() => _MLHomeFragmentState();
}

class _MLHomeFragmentState extends State<MLHomeFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DashboardScreen(),
          ],
        ),
      ),
    );
  }
}
