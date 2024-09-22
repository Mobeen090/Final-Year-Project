import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../appConfig.dart';
import '../../constants/appImagePaths.dart';
import '../../constants/colors.dart';
import '../../constants/customInputFormator.dart';
import '../../constants/routes.dart';
import '../customWidgets/rounded_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final ImagePicker _picker = ImagePicker();
  late XFile? image;
  String? imageBase64='';


  @override
  void initState() {
    super.initState();
    image=null;
  }

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  TextEditingController _nameEditor= TextEditingController();
  TextEditingController _emailEditor= TextEditingController();
  TextEditingController _phoneEditor= TextEditingController();
  TextEditingController _passEditor= TextEditingController();
  TextEditingController _cnfrmPassEditor= TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SizedBox(
           width: 1.sw,
           child: Column(
             children: [
               Padding(
                 padding: EdgeInsets.all(18.r),
                 child: Column(
                   children: [

                     Padding(
                       padding: EdgeInsetsDirectional.only(top: 90.h),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Image.asset(AppImages.appLogo),
                         ],
                       ),
                     ),

                     SizedBox(
                       height: 40.h,
                     ),

                     Align(
                       alignment: Alignment.topCenter,
                       child:  GestureDetector(
                         onTap:() => cameraPermission(context),
                         child: Container(
                           width: 80.r,
                           height: 80.r,
                           decoration: BoxDecoration(
                             shape: BoxShape.circle,
                             color: const Color(0xffD9D9D9),
                             border: Border.all(
                               color: appThemeColor,
                               width: 2.w,
                             ),
                           ),
                           child: image == null ? Center(
                             child: Image.asset(AppImages.iconSignUpAvatar,height: 35.r,width: 35.r,),
                           ) : ClipOval(
                             child: Image.file(
                               File(image!.path),
                               fit: BoxFit.cover,
                               width: 80.r,
                               height: 80.r,
                             ),
                           ),
                         ),
                       ),
                     ),

                     SizedBox(
                       height: 40.h,
                     ),

                     Padding(
                       padding:
                           EdgeInsetsDirectional.only(start: 6.r, end: 6.r),
                       child: TextFormField(
                       controller: _nameEditor,
                         cursorColor: appThemeColor,
                         inputFormatters: [
                           CustomFormatter(),
                         ],
                         decoration: InputDecoration(
                           contentPadding: EdgeInsetsDirectional.symmetric(
                               horizontal: 20.w),
                           hintText: "Name",
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
                         cursorColor: appThemeColor,
                         controller: _emailEditor,
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
                         controller: _phoneEditor,
                         cursorColor: appThemeColor,
                         inputFormatters: [
                           CustomFormatter(),
                         ],
                         decoration: InputDecoration(
                           contentPadding: EdgeInsetsDirectional.symmetric(
                               horizontal: 20.w),
                           hintText: "Phone No",
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
                         controller: _passEditor,
                         obscureText: _isPasswordHidden,
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
                                 _isPasswordHidden = !_isPasswordHidden;
                               });
                             },
                             child: Padding(
                               padding: EdgeInsetsDirectional.only(end: 20.w),
                               child: Icon(
                                 _isPasswordHidden
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
                     SizedBox(height: 20.h),
                     Padding(
                       padding:
                           EdgeInsetsDirectional.only(start: 6.r, end: 6.r),
                       child: TextFormField(
                         controller: _cnfrmPassEditor,
                         obscureText: _isConfirmPasswordHidden,
                         cursorColor: appThemeColor,
                         decoration: InputDecoration(
                           contentPadding: EdgeInsetsDirectional.symmetric(
                               horizontal: 20.w),
                           hintText: "Confirm Password",
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
                                 _isConfirmPasswordHidden =
                                     !_isConfirmPasswordHidden;
                               });
                             },
                             child: Padding(
                               padding: EdgeInsetsDirectional.only(end: 20.w),
                               child: Icon(
                                 _isConfirmPasswordHidden
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
                     Padding(
                       padding:
                           EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
                       child: SizedBox(
                         width: 1.sw,
                         height: 44.h,
                         child: RoundedButton(
                           buttonText: 'Sign Up',
                           onPressed: (){
                             requestSignUp(context);

                           },
                           buttonColor: appThemeColor,
                           textColor: Colors.white,
                           shouldTextBold: false,
                           buttonTextSize: 18.sp,
                         ),
                       ),
                     ),
                     SizedBox(height: 30.h),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Text(
                           'Already have account? ',
                           style: TextStyle(
                               color: const Color(0xff606060),
                               fontSize: 16.sp),
                         ),
                         GestureDetector(
                           onTap: () => navToSignInScreen(context),
                           child: Text(
                             'SIGN IN',
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
         ),
      ),
    );
  }

  navToSignInScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  void requestSignUp(BuildContext context) {

    if(image == null){
      AppConfig().displayError(context, "Please Insert Your Image First.");

    }
    else if(_nameEditor.text.toString().isEmpty) {
      AppConfig().displayError(context, "Please Enter Your Name");

      }
    else if(AppConfig().validateEmail(_emailEditor.text.toString()) == false){

      AppConfig().displayError(context, "Email Invalid");

    }
    else if( _phoneEditor.text.toString().isEmpty  ){

      AppConfig().displayError(context, "Please Enter Phone Number");

    }
    else if(_passEditor.text.toString().isEmpty){

      AppConfig().displayError(context, "Please Enter Password");

    }
    else if(_cnfrmPassEditor.text.toString().isEmpty){

      AppConfig().displayError(context, "Please Enter Confirm Password");

    }
    else if(_passEditor.text.toString().length < 6){

      AppConfig().displayError(context, "Password must be greater than 6 characters");

    }else if( _passEditor.text.toString() != _cnfrmPassEditor.text.toString() ){

      AppConfig().displayError(context, "Password Does Not Match");
    }
    else{

    _register(context);

    }


  }


  Future<void> _register(BuildContext context) async {

    EasyLoading.show();
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailEditor.text.trim(),
        password: _passEditor.text.trim(),
      );

      // Set the display name
      await userCredential.user?.updateDisplayName(_nameEditor.text.trim());

      imageBase64= await AppConfig().convertImageToBase64(image!);

      // Store additional user details in Firestore
      await _firestore.collection('registered users').doc(userCredential.user!.uid).set({
        'image': imageBase64 ,
        'name': _nameEditor.text.trim(),
        'phone': _phoneEditor.text.trim(),
      });


      EasyLoading.dismiss();
      print("Registration successful!");

      navToSignInScreen(context);

    } catch (e) {
      EasyLoading.dismiss();
      print("Error during registration: $e");

      AppConfig().displayError(context, AppConfig().convertFirebaseErrorMessage(e.toString()));


    }finally{
      EasyLoading.dismiss();
    }
  }


  Future<void> cameraPermission(context) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      requestCameraPermision(context);
      print("Permission is denined.");
    }
    else if (status.isGranted) {
      //permission is already granted.
      showUploadBottomSheet(context);
      print("Permission is already granted.");
    }
    else if (status.isPermanentlyDenied) {
      //permission is permanently denied.
      // requestCameraPermision(context);
      AppConfig().displayInfo(context,"Phone has blocked camera permission.Please go to setting and grant it manually.");
      print("Permission is permanently denied");
    }
    else if (status.isRestricted) {
      //permission is OS restricted.
      requestCameraPermision(context);
      print("Permission is OS restricted.");
    }
    else {
      requestCameraPermision(context);
    }
  }

  Future<void> requestCameraPermision(context) async {

    if (await Permission.camera.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      print("camera Permission is granted");
      showUploadBottomSheet(context);
    } else {

      cameraPermission(context);


      print("camera Permission is denied.");
    }
  }

  _getFromCamera(context) async {
    image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 82.34.w,
        maxHeight: 96.68.h,
        imageQuality: 90);
    if (image != null) {
      setState(()  {
        // _load = true;
        // if (selectedImageList.length <= 2) {
        //   selectedImageList.add(PrescriptionPhotoModel(path: image!.path));
        // } else {
        //   showAlertDialog(context, Strings.newPrescriptionAlertDialogText);
        // }
        //
      });
    }
    // Navigator.pop(context);
  }

  _getFromGallery(context) async {
    image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 82.34.w,
        maxHeight: 96.68.h,
        imageQuality: 90);
    if (image != null) {
      setState(()  {


        // _load = true;
        // if (selectedImageList.length <= 2) {
        //   selectedImageList.add(PrescriptionPhotoModel(path: image!.path));
        // } else {
        //   showAlertDialog(context, Strings.newPrescriptionAlertDialogText);
        // }
      });
    }
    // Navigator.pop(context);
  }


  void showUploadBottomSheet(context) {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 0.35.sh,
            child: Column(
              children: [
                Container(
                  height: 0.07.sh,
                  width: 1.sw,
                  child: Center(
                    child: Text(
                      "Pick Image",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.2.h),
                    ),
                  ),
                ),
                const Divider(
                  height: 0.1,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _getFromCamera(context);
                    },
                    child: Container(
                      height: 0.06.sh,
                      width: 1.sw,
                      child: Center(
                        child: Text(
                          "Camera",
                          style: TextStyle(
                              color: appThemeColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.2.h),
                        ),
                      ),
                    )),
                const Divider(
                  height: 0.1,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _getFromGallery(context);
                    },
                    child: Container(
                      height: 0.07.sh,
                      width: 1.sw,
                      child: Center(
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                              color: appThemeColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.2.h),
                        ),
                      ),
                    )),
                const Divider(
                  height: 0.1,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(top: 50.47.h),
                  child:RoundedButton(buttonText: "Cancel", onPressed: (){
                    Navigator.pop(context);
                  }, buttonColor: appThemeColor, textColor: Colors.white, shouldTextBold: false, buttonTextSize: 16.sp),
                )
              ],
            ),
          );
        },
        backgroundColor: Colors.white,
        barrierColor: Color(0xFF1A1A1A).withOpacity(0.7),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.17.r))),
        clipBehavior: Clip.hardEdge);
  }


}

