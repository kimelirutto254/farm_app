import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ifms/screens/farmers/MLLoginScreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ifms/api/my_api.dart';
import 'package:ifms/utils/MLCommon.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ifms/screens/MLDashboardScreen.dart';
import 'package:ifms/utils/MLColors.dart';

class CreateAccountScreen extends StatefulWidget {
  static String tag = '/CreateAccountScreen';

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController namesController = TextEditingController();
  TextEditingController routeController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  _register() async {
    if (pinController.text.length != 4) {
      toast('PIN must be exactly 4 digits');
      return;
    }

    Fluttertoast.showToast(
      msg: "Creating account...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Map<String, dynamic> data = {
      'username': usernameController.text,
      'id_number': idNumberController.text,
      'name': namesController.text,
      'route': routeController.text,
      'pin': pinController.text,
    };

    var res = await CallApi().postData(data, 'create-account');

    if (res['status'] == true) {
      Fluttertoast.showToast(
        msg: res['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MLLoginScreen()),
      );
    } else {
      Fluttertoast.showToast(
        msg: res['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
            margin: EdgeInsets.only(top: 120),
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
                    40.height,
                    Text("Create Account", style: boldTextStyle(size: 20)),
                    16.height,
                    AppTextField(
                      controller: usernameController,
                      textFieldType: TextFieldType.NAME,
                      decoration: InputDecoration(labelText: 'User Name'),
                    ),
                    16.height,
                    AppTextField(
                      controller: idNumberController,
                      textFieldType: TextFieldType.NUMBER,
                      decoration: InputDecoration(labelText: 'ID Number'),
                    ),
                    16.height,
                    AppTextField(
                      controller: namesController,
                      textFieldType: TextFieldType.NAME,
                      decoration: InputDecoration(labelText: 'Full Names'),
                    ),
                    16.height,
                    AppTextField(
                      controller: routeController,
                      textFieldType: TextFieldType.NAME,
                      decoration: InputDecoration(labelText: 'Route'),
                    ),
                    16.height,
                    Text("PIN", style: boldTextStyle(size: 14)),
                    4.height,
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
                        inactiveColor: Colors.grey,
                        activeColor: Colors.grey,
                        selectedColor: Colors.grey,
                        borderWidth: 1.5,
                      ),
                    ),
                    24.height,
                    AppButton(
                      color: mlPrimaryColor,
                      width: double.infinity,
                      onTap: _register,
                      child: Text("Create Account",
                          style: boldTextStyle(color: white)),
                    ),
                    22.height,
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
