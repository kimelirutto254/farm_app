import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ifms/api/my_api.dart';
import 'package:ifms/screens/farmers/createaccount.dart';
import 'package:ifms/utils/MLCommon.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ifms/screens/MLDashboardScreen.dart';
import 'package:ifms/utils/MLColors.dart';
import 'package:ifms/utils/MLString.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class MLLoginScreen extends StatefulWidget {
  static String tag = '/MLLoginScreen';

  @override
  _MLLoginScreenState createState() => _MLLoginScreenState();
}

class _MLLoginScreenState extends State<MLLoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    changeStatusColor(mlPrimaryColor);
  }

  _login() async {
    Fluttertoast.showToast(
      msg: "Please wait ...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Map<String, dynamic> data = {
      'username': usernameController.text,
      'pin': pinController.text,
    };

    var res = await CallApi().postData(data, 'login');
    print(data);
    if (res['status'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', res['token']);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('user', jsonEncode(res['user']));
      Fluttertoast.showToast(
        msg: "Login successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MLDashboardScreen()),
      );
    } else {
      Fluttertoast.showToast(
        msg: res['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Image.asset('images/logo_farmexceed.png', height: 80),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 130),
            height: context.height(),
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: radiusOnly(topRight: 32),
              backgroundColor: context.cardColor,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
                    Text(mlLogin_title!, style: boldTextStyle(size: 20)),
                    16.height,

                    // Username Label & Input
                    Text("Username", style: boldTextStyle(size: 14)),
                    4.height,
                    AppTextField(
                      controller: usernameController,
                      textFieldType: TextFieldType.NAME,
                      decoration: InputDecoration(
                        labelText: 'Enter your username',
                        labelStyle: secondaryTextStyle(size: 16),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: mlColorLightGrey.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    16.height,

                    // PIN Label & OTP Fields
                    Text("Enter your pin", style: boldTextStyle(size: 14)),
                    16.height,
                    PinCodeTextField(
                      appContext: context,
                      length: 4,
                      controller: pinController,
                      obscureText: true,
                      obscuringCharacter: '*',
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 60,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveColor: Colors.grey, // Black border
                        activeColor: Colors.grey, // Black border
                        selectedColor: Colors.grey, // Black border
                        borderWidth: 1.5, // Thicker border
                      ),
                    ),

                    24.height,

                    // Login Button
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            color: mlPrimaryColor,
                            onTap: () {
                              if (usernameController.text.isEmpty ||
                                  pinController.text.isEmpty) {
                                toast('Please enter username and PIN');
                              } else {
                                _login();
                              }
                            },
                            child: Text(mlLogin!,
                                style: boldTextStyle(color: white)),
                          ),
                        ),
                        16.width, // Spacing between buttons
                        Expanded(
                          child: SizedBox(
                            height: 50, // Ensures a square shape
                            width: 50, // Ensures a square shape
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateAccountScreen()),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: mlPrimaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.zero, // Ensures sharp edges
                                ),
                              ),
                              child: Text(
                                "Signup",
                                style: boldTextStyle(
                                    color: mlPrimaryColor, size: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    22.height,
                    // Create Account Button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
