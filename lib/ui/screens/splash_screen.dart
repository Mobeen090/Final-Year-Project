import 'package:flutter/material.dart';
import '../../appConfig.dart';
import '../../constants/appImagePaths.dart';
import '../../constants/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppImages.appLogo),
      ),
    );


  }

  @override
  void initState() {
  super.initState();
  init(context);
  }

  void init(BuildContext context) async{
    await Future.delayed(const Duration(seconds: 2));

    bool isUserLoggedIn = await AppConfig().getIsUserLoggedIn();

    if(isUserLoggedIn == true){

      Navigator.pushNamed(context, Routes.navigatorRoute);

    }else{
      Navigator.pushNamed(context, Routes.introRoute);

    }
  }

}
