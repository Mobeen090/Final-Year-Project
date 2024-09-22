import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/colors.dart';
import 'constants/routes.dart';

class AppConfig {
  AppConfig.internal();

  User? user;

  static final AppConfig _singelton = AppConfig.internal();

  factory AppConfig() {
    return _singelton;
  }

  navBack(BuildContext context) {
    Navigator.pop(context);
  }

  bool? validateEmail(String value) {
    // Simple email validation
    if (value.isEmpty) {
      return false;
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  void displayError(BuildContext context, String errorText) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error...',
        text: errorText,
        confirmBtnColor: appThemeColor);
  }

  void displayInfo(BuildContext context, String infoText) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Logout...',
        text: infoText,
        cancelBtnTextStyle: TextStyle(color: appThemeColor),
        confirmBtnColor: appThemeColor,
        confirmBtnText: "Yes",
        cancelBtnText: "No",
        showCancelBtn: true,
        onConfirmBtnTap: () {
          navToLoginScreen(context);
        },
    );
  }

  void displaySuccessDialog(BuildContext context, String successText) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success...',
        text: successText,
        confirmBtnColor: appThemeColor,
        barrierDismissible: false,
        onConfirmBtnTap: () {
          Navigator.pop(context);
        });
  }

  Future<String?> convertImageToBase64(XFile image) async {
    // Read the image file as bytes
    Uint8List imageBytes = await image.readAsBytes();

    // Encode the image bytes to base64
    String base64 = base64Encode(imageBytes);

    return base64;
  }

  String convertFirebaseErrorMessage(String error) {
    // Define a regular expression pattern to match the error prefix and its contents
    RegExp regex = RegExp(r"\[.*?\]");

    // Replace the matched pattern with an empty string
    return error.replaceAll(regex, '');
  }

  convertImageByte(String base64Image) {
    List<int> imageBytes = base64.decode(base64Image);
    return imageBytes;
  }

  navToLoginScreen(BuildContext context) async {
    AppConfig().setIsUserLoggedIn(false);
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.loginRoute,
      (Route<dynamic> route) => false,
    );
  }

  setIsUserLoggedIn(_checkUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userLoggedIn', _checkUser);
  }

  getIsUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('userLoggedIn')?? false;
    return boolValue;
  }

}
