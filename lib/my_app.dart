import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constants/colors.dart';
import 'constants/routes.dart';
import 'ui/customWidgets/BottomNavigationScreen.dart';
import 'ui/screens/Home Screens/ViewItemDetailScreen.dart';
import 'ui/screens/Home Screens/termsAndCondition.dart';
import 'ui/screens/IntroScreens/intro_screen.dart';
import 'ui/screens/IntroScreens/intro_screen_one.dart';
import 'ui/screens/forgot_pass_screen.dart';
import 'ui/screens/sign_in_screen.dart';
import 'ui/screens/sign_up_screen.dart';
import 'ui/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(414, 853),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        builder: ((context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner:false,
            title: "TALAASH App",
            builder: (context, child) => _initEasyLoading(context, child),
            initialRoute:Routes.splashRoute,
            routes: {
              Routes.splashRoute: (context) => const SplashScreen(),
              Routes.introRoute: (context) => const IntroScreen(),
              Routes.introOneRoute: (context) => const IntroScreenOne(),
              Routes.loginRoute: (context) =>  SignIn(),
              Routes.signUpRoute: (context) =>  SignUpScreen(),
              Routes.forgotPassRoute: (context) =>   ForgotPasswordScreen(),
              Routes.navigatorRoute: (context) =>   const BottomNavigationScreen(),
              Routes.itemDetailRoute: (context) =>   const ViewItemDetails(),
              Routes.termsAndConditionScreenRoute: (context) =>    TermsAndConditionsScreen(),
            },
          );
        }
        ),
    );
  }

  Widget _initEasyLoading(BuildContext context, Widget? child) {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1000)
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.light
      ..indicatorSize = 40.sp
      ..radius = 10.r
      ..maskType = EasyLoadingMaskType.black
      ..backgroundColor = Colors.transparent
      ..indicatorColor = appThemeColor
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..textColor = Colors.transparent
      ..fontSize = 14.sp
      ..maskColor = Colors.transparent
      ..userInteractions = false
      ..dismissOnTap = false;

    return EasyLoading.init()(context, child);
  }
}

