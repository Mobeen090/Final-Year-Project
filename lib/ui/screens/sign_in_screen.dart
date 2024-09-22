import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../appConfig.dart';
import '../../constants/appImagePaths.dart';
import '../../constants/colors.dart';
import '../../constants/routes.dart';
import '../customWidgets/rounded_button.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool rememberMe = false;
  bool _isObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: 1.sw,
            height: 1.sh,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 100.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppImages.appLogo),
              ],
            ),
          ),
          Container(
            width: 1.sw,
            height: 1.sh,
            margin: EdgeInsetsDirectional.only(top: 240.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(18.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40.h,
                      ),

                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 6.r, end: 6.r),
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: appThemeColor,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsetsDirectional.symmetric(
                                horizontal: 20.w),
                            hintText: "Email",
                            filled: true,
                            fillColor: const Color(0xffF3F5F7),
                            hintStyle: const TextStyle(
                              color: Color(0xffBDBDBD),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.r)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffF3F5F7), // Border color
                                ),
                                borderRadius: BorderRadius.circular(30.r)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffF3F5F7), // Border color
                                ),
                                borderRadius: BorderRadius.circular(30.r)),
                          ),
                          style: const TextStyle(color: appThemeColor),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 6.r, end: 6.r),
                        child: TextFormField(
                          obscureText: _isObscure,
                          controller: passController,
                          cursorColor: appThemeColor,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsetsDirectional.symmetric(
                                horizontal: 20.w),
                            hintText: "Password",
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
                                color: Color(0xffF3F5F7),
                              ),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffF3F5F7),
                              ),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(end: 20.w),
                                child: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          style: const TextStyle(color: appThemeColor),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      GestureDetector(
                        onTap: () => navToForgotScreen(),child: Text(
                          'FORGOT PASSWORD',
                          style: TextStyle(color: appThemeColor,fontSize: 16.sp),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
                        child: SizedBox(
                          width: 1.sw,
                          height: 44.h,
                          child: RoundedButton(
                            buttonText: 'Sign in',
                            onPressed: () => requestSignIn(),
                            buttonColor: appThemeColor,
                            textColor: Colors.white,
                            shouldTextBold: false,
                            buttonTextSize: 18.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have account? ',
                            style: TextStyle(
                                color: const Color(0xff606060),
                                fontSize: 16.sp),
                          ),
                          GestureDetector(
                            onTap: () => navToSignUpScreen(),
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                  color: appThemeColor, fontSize: 16.sp),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  navToSignUpScreen() {
    Navigator.pushReplacementNamed(context, Routes.signUpRoute);
  }

  navToForgotScreen() {
    Navigator.pushNamed(context, Routes.forgotPassRoute);
  }

  requestSignIn() async {

    if(emailController.text.toString().isEmpty){
      AppConfig().displayError(context, "Please Enter Your Email");

    }
    else if(AppConfig().validateEmail(emailController.text.toString()) == false){

      AppConfig().displayError(context, "Email Invalid");

    }else if(passController.text.toString().isEmpty){
      AppConfig().displayError(context, "Please Enter Your Password");

    }else{

      EasyLoading.show();

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passController.text.trim());
        AppConfig().user = userCredential.user;

        EasyLoading.dismiss();
        print("Registration successful!");
        navToHomeScreen();
      } catch (e) {
        EasyLoading.dismiss();
        print("Error during registration: $e");
        AppConfig().displayError(context, AppConfig().convertFirebaseErrorMessage(e.toString()));
      } finally {
        EasyLoading.dismiss();
      }
    }

  }

  void navToHomeScreen() {
    AppConfig().setIsUserLoggedIn(true);
    Navigator.pushNamed(context, Routes.navigatorRoute);
  }
}
