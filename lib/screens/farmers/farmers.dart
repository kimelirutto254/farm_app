import 'package:flutter/material.dart';
import 'package:ifms/api/ApiProvider.dart';
import 'package:ifms/api/my_api.dart';
import 'package:ifms/main.dart';
import 'package:ifms/model/farmers.dart';
import 'package:ifms/screens/farmers/editfarmer.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:provider/provider.dart';

class FarmersList extends StatefulWidget {
  static String tag = '/FarmersList';

  @override
  _FarmersListState createState() => _FarmersListState();
}

class _FarmersListState extends State<FarmersList> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FarmersProvider>(context, listen: false)
          .fetchInitialFarmers(); // Load only 10 farmers initially
    });
  }

  void _onSearch(String query) async {
    setState(() {
      searchQuery = query;
      isSearching = query.isNotEmpty;
    });

    if (query.isNotEmpty) {
      await Provider.of<FarmersProvider>(context, listen: false)
          .searchFarmers(query);
    }
  }

  // Function to show modal dialog

  @override
  Widget build(BuildContext context) {
    final farmersProvider = Provider.of<FarmersProvider>(context);

    // List to display (either search results or initial farmers)
    final List<Farmer> displayFarmers = isSearching
        ? farmersProvider.searchedFarmers // API search results
        : farmersProvider.initialFarmers; // Initial 10 farmers

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mlPrimaryColor,
        automaticallyImplyLeading: false, // Remove back button
        title: Text('Farmers List', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search Bar Below AppBar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Farmers...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _onSearch,
            ),
          ),

          // Farmers List
          Expanded(
            child: farmersProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: displayFarmers.length,
                    itemBuilder: (context, index) {
                      final farmer = displayFarmers[index];
                      return GestureDetector(
                        onTap: () {
                          TextEditingController idController =
                              TextEditingController();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Verify Farmer"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: idController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "Enter Farmer ID",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close modal
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      String enteredId =
                                          idController.text.trim();
                                      if (enteredId.isNotEmpty) {
                                        Map<String, dynamic> data = {
                                          'id_number': idController.text,
                                          'user_id': farmer.growerId,
                                        };

                                        var res = await CallApi().postData(
                                            data, 'verifyUserIdAndIdNumber');
                                        print("API Response: $res");

                                        if (res['status'] == true) {
                                          // Close the current screen/dialog first

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditFarmerScreen(
                                                      growerid: farmer.growerId
                                                          .toInt()),
                                            ),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: res['message'],
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                      } else {
                                        toast("Please enter a valid ID");
                                      }
                                    },
                                    child: Text("Verify"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 8.0),
                          padding: EdgeInsets.all(12),
                          decoration: boxDecorationWithRoundedCorners(
                            backgroundColor: appStore.isDarkModeOn
                                ? scaffoldDarkColor
                                : Colors.white,
                            borderRadius: radius(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                radius: 20,
                                child: Text(
                                  farmer.firstName[0],
                                  style: boldTextStyle(color: Colors.white),
                                ),
                              ),
                              12.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${farmer.firstName} ${farmer.lastName}',
                                        style: boldTextStyle(size: 16)),
                                    4.height,
                                    Text('Grower ID: ${farmer.growerId}',
                                        style: secondaryTextStyle()),
                                    4.height,
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            farmer.inspectionStatus ??
                                                'Pending',
                                            style: boldTextStyle(
                                                color: Colors.white, size: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    8.height,
                                    Text(
                                      'Location: ${farmer.buyingCenter ?? 'No location'}',
                                      style: secondaryTextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                      color: mlPrimaryColor, size: 16)
                                  .onTap(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditFarmerScreen(
                                        growerid: farmer.growerId.toInt()),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ).paddingBottom(12.0),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
