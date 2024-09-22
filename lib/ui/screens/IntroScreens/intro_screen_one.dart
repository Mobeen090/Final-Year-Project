import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/appImagePaths.dart';
import '../../../constants/colors.dart';
import '../../../constants/routes.dart';
import '../../customWidgets/rounded_button.dart';

class IntroScreenOne extends StatelessWidget {
  const IntroScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        SizedBox(height: 1.sh, width: 1.sw,child: Image.asset(AppImages.introOneBackground,fit: BoxFit.fill,),),

        Padding(
          padding:  EdgeInsetsDirectional.only(top:100.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImages.appLogo),
            ],
          ),
        ),

        SizedBox(
          height: 1.sh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.h,),
              Container(width: 1.sw,height: 45.h,padding: EdgeInsetsDirectional.only(start: 30.r,end: 30.r),child: RoundedButton(buttonText: "Sign In", onPressed: () => navToSingInScreen(context), buttonColor: Colors.white, textColor: appThemeColor, shouldTextBold: true, buttonTextSize: 18.sp,)),
              SizedBox(height: 25.h,),
              Container(width: 1.sw,height: 45.h,padding: EdgeInsetsDirectional.only(start: 30.r,end: 30.r),child: RoundedButton(buttonText: "Sign Up", onPressed: () => navToSingUpScreen(context), buttonColor: Colors.white, textColor: appThemeColor, shouldTextBold: true, buttonTextSize: 18.sp,)),
            ],
          ),
        )
      ],
    );
  }

  navToSingInScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.loginRoute);

  }

  navToSingUpScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.signUpRoute);

  }
}
