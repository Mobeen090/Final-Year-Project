import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import '../../appConfig.dart';
import '../../constants/appImagePaths.dart';
import '../../constants/colors.dart';
import '../customWidgets/rounded_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 32.r,
        ),
        iconTheme: IconThemeData(color: appThemeColor),
        centerTitle: true,
        title: Image.asset(AppImages.appLogo),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TYPE YOUR EMAIL',
              style: TextStyle(color: appThemeColor, fontSize: 16.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.greenAccent,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  top: 16.r,
                  bottom: 16.r,
                  start: 20.r,
                  end: 20.r,
                ),
                child: Text(
                  "We will send you instructions on how to reset your password",
                  style: TextStyle(
                    color: Color(0xff242424),
                    fontSize: 16.sp,
                    height: 2.h,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 34.h,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 6.r, end: 6.r),
              child: TextFormField(
                controller: _email,
                cursorColor: appThemeColor,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                  hintText: "Email",
                  filled: true,
                  fillColor: const Color(0xffF3F5F7),
                  hintStyle: const TextStyle(
                    color: Color(0xffBDBDBD),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xffF3F5F7), // Border color
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xffF3F5F7), // Border color
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                style: const TextStyle(color: appThemeColor),
                onFieldSubmitted: (String? value) {},
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
              child: SizedBox(
                width: 1.sw,
                height: 44.h,
                child: RoundedButton(
                  buttonText: 'SEND',
                  onPressed: () => requestNewPassword(context),
                  buttonColor: appThemeColor,
                  textColor: Colors.white,
                  shouldTextBold: false,
                  buttonTextSize: 18.sp,
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  requestNewPassword(BuildContext context) async {
    String email = _email.text.toString().trim();
    if (_email.text.toString().isEmpty) {
      AppConfig().displayError(context, "Invalid Email");
    } else if (AppConfig().validateEmail(_email.text.toString()) == true) {
      try {
        // Display a success message
        AppConfig().displaySuccessDialog(
            context, "Password reset email sent to $email");
        // Delay for a short period to let the user see the success dialog
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        await Future.delayed(Duration(seconds: 4));
        // Navigate back to the sign-in screen after a short delay
        Navigator.pushReplacementNamed(context, '/LoginPage');
      } catch (e) {
        // Display an error message
        print("Error sending password reset email: $e");
        Navigator.pop(context);
      }
    } else {
      AppConfig().displayError(context, "Invalid Email");
    }
  }
}
