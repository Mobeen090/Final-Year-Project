import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../appConfig.dart';
import '../../../constants/appImagePaths.dart';
import '../../../constants/colors.dart';
import '../../customWidgets/rounded_button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String? image;
  String? name='';
  String? email='';
  String? phone='';
  late List<int> imageBytes;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
   EasyLoading.show();
    try {
      // Replace 'your_collection' with the actual name of your Firestore collection
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('registered users').doc(AppConfig().user!.uid).get();

      if (snapshot.exists) {
        // Update the state with the fetched data
        setState(() {

          image = snapshot['image'] ?? ''; // Replace 'name' with the actual field name in your document
          name = snapshot['name'] ?? ''; // Replace 'name' with the actual field name in your document
          email = AppConfig().user!.email;
          phone = snapshot['phone'] ?? ''; // Replace 'phone' with the actual field name in your document
          imageBytes = base64Decode(image!);

        });
      } else {
        EasyLoading.dismiss();
        AppConfig().displayError(context, 'Document does not exist');
        print('Document does not exist');
      }
    } catch (error) {
      EasyLoading.dismiss();
      print('Error fetching data: $error');
      AppConfig().displayError(context,  AppConfig().convertFirebaseErrorMessage(error.toString()));
    }finally{
      EasyLoading.dismiss();

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: SizedBox(
          width: 1.sw,
          height: 1.sh,
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                CircleAvatar(
                radius: 70.r,
                  backgroundImage: image != null
                      ? Image.memory(Uint8List.fromList(imageBytes)).image
                      : const AssetImage(AppImages.iconAvatar),) ,
              SizedBox(height: 20.h),
              Text(
                name.toString(),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
              email.toString(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                phone.toString(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 30.h),

              Padding(
                padding: EdgeInsetsDirectional.only(start: 80.r,end: 80.r),
                child: SizedBox(
                  width: 1.sw,
                  height: 44.h,
                  child: RoundedButton(
                    buttonText: 'Log Out',
                    onPressed: () =>{

                      AppConfig().displayInfo(context,"Are you sure you want to logout...?")
                    } ,
                    buttonColor: appThemeColor,
                    textColor: Colors.white,
                    shouldTextBold: false,
                    buttonTextSize: 18.sp,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }



}
