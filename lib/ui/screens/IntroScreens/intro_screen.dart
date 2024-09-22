import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/appImagePaths.dart';
import '../../../constants/colors.dart';
import '../../../constants/routes.dart';
import '../../customWidgets/rounded_button.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false; // Return false to prevent the default behavior (pop the current route)
      },
      child:
      Stack(
      children: [

        SizedBox(
          width: 1.sw,
          height: 1.sh,
          child: Image.asset(AppImages.introBackground, fit: BoxFit.fill),
        ),

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

        Padding(
          padding:EdgeInsets.only(bottom: 50.h),
          child: Align(alignment: Alignment.bottomCenter,
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsetsDirectional.only(start: 40.r,end: 40.r),
                width: 1.sw,child: Align(alignment: Alignment.center,
                  child: Text(
                    "Let's simplify the search for anything, Making it easier to find.",
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 30.h,),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 1.sw/1.5,
                  height: 45.h,child: RoundedButton(buttonText: 'Let\'s Explore ->', onPressed: () {
                    navToIntroOneScreen(context);
                  }, buttonColor: appThemeColor, textColor: Colors.white, shouldTextBold: true, buttonTextSize: 20.sp,),
                ),
              ),
            ],
            )

          ),
        ),

      ],
    ) ,);
  }

  void navToIntroOneScreen(BuildContext context) {
    Navigator.pushNamed(context, Routes.introOneRoute);

  }


}

