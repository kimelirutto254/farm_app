import 'package:flutter/material.dart';
import 'package:ifms/screens/farmers/farmers.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: mlPrimaryColor,
          automaticallyImplyLeading: false,
          title: Text(
            "My Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                // "Good Morning" Section with White Background
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        "Good Morning, Dev",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),

                // Search Section
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FarmersList()), // Replace with your FarmerListScreen
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the content vertically
                      children: [
                        Icon(Icons.search, size: 60, color: Colors.green),
                        Text(
                          "Search Farmers",
                          style: TextStyle(
                            color: const Color.fromRGBO(76, 175, 80, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 16),
                Text(
                  "My Statistics",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Statistics Section
                Container(
                  color: mlPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        "Complete Inspections",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(
                        height: 16,
                        thickness: 1,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatBox("Today", "0"),
                            _buildStatBox("Weekly", "0"),
                            _buildStatBox("Total", "0"),
                            _buildStatBox("Approved", "0"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Status Boxes Section
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatusBox(
                            "Incomplete",
                            "0 Inspections",
                            Colors.blue.shade200,
                          ),
                          _buildStatusBox(
                            "Rejected",
                            "0 Inspections",
                            Colors.red.shade200,
                          ),
                        ],
                      ),
                      SizedBox(height: 8), // Adding spacing between rows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatusBox(
                            "No Point",
                            "0 Inspections",
                            Colors.orange.shade200,
                          ),
                          _buildStatusBox(
                            "No Polygon",
                            "0 Inspections",
                            Colors.green.shade200,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildStatBox(String title, String value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 1),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: 16,
            ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBox(String title, String count, Color color) {
    return Container(
      width: 120, // Adjust as needed
      margin: EdgeInsets.symmetric(horizontal: 0),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Column(
            children: [
              Divider(
                color: Colors.grey.shade100,
                thickness: 1,
                height: 16,
              ),
              Text(
                count.split(" ")[0], // Extracts "0"
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                count.split(" ")[1], // Extracts "Inspections"
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
