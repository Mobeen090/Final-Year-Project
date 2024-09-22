import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../appConfig.dart';
import '../../../constants/appImagePaths.dart';
import '../../../constants/colors.dart';
import '../../../constants/customInputFormator.dart';
import '../../../models/lostAndfound_model.dart';
import '../../customWidgets/rounded_button.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String? _selectedCategoryItem;

  String? _selectedColorItem;

  String? _selectedLostFoundItem;

  TextEditingController _nameEditor = TextEditingController();
  TextEditingController _addressEditor = TextEditingController();
  TextEditingController _durationEditor = TextEditingController();
  TextEditingController _descriptionEditor = TextEditingController();

  // List of items for the dropdown
  final List<String> _dropdownCategories = [
    'Mobile',
    'Wallet',
    'Purse',
    'Laptop',
    'File',
    'Bag',
    'Suit-Case',
    'Card',
    'Keys',
    'Child',
    'Pet',
    'Car',
    'Bike',
    'Others',
  ];

  final List<String> _dropdownColor = [
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Orange',
    'Purple',
    'Pink',
    'Brown',
    'Black',
    'White',
  ];

  final List<String> _dropdownItemListed = [
    'Lost',
    'Found',
  ];

  final ImagePicker _picker = ImagePicker();
  late XFile? image;
  String? imageBase64 = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    image = null;

    AppConfig().user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 35.h,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () => cameraPermission(context),
                child: Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffD9D9D9),
                    border: Border.all(
                      color: appThemeColor,
                      width: 2.w,
                    ),
                  ),
                  child: image == null
                      ? Center(
                          child: Image.asset(
                            AppImages.iconCamera,
                            height: 35.r,
                            width: 35.r,
                          ),
                        )
                      : ClipOval(
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
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
              child: TextFormField(
                controller: _nameEditor,
                cursorColor: appThemeColor,
                inputFormatters: [
                  CustomFormatter(),
                ],
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                  hintText: "Name",
                  filled: true,
                  fillColor: const Color(0xffF3F5F7),
                  hintStyle: const TextStyle(
                    color: Color(0xffBDBDBD),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffF3F5F7), // Border color
                      ),
                      borderRadius: BorderRadius.circular(8.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffF3F5F7), // Border color
                      ),
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                style: const TextStyle(color: appThemeColor),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
              child: TextFormField(
                controller: _addressEditor,
                cursorColor: appThemeColor,
                inputFormatters: [
                  CustomFormatter(),
                ],
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                  hintText: "Address",
                  filled: true,
                  fillColor: const Color(0xffF3F5F7),
                  hintStyle: const TextStyle(
                    color: Color(0xffBDBDBD),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffF3F5F7), // Border color
                      ),
                      borderRadius: BorderRadius.circular(8.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffF3F5F7), // Border color
                      ),
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                style: const TextStyle(color: appThemeColor),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
              child: TextFormField(
                maxLines: 2,
                controller: _durationEditor,
                cursorColor: appThemeColor,
                inputFormatters: [
                  CustomFormatter(),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsetsDirectional.symmetric(
                      horizontal: 20.w, vertical: 10.h),
                  hintText: "Time (you can also write in roman urdu)",
                  filled: true,
                  fillColor: const Color(0xffF3F5F7),
                  hintStyle: const TextStyle(
                    color: Color(0xffBDBDBD),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffF3F5F7), // Border color
                      ),
                      borderRadius: BorderRadius.circular(8.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffF3F5F7), // Border color
                      ),
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                style: const TextStyle(color: appThemeColor),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
              child: Container(
                width: 1.sw,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Color(0xffF3F5F7)),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: 20.w),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategoryItem,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategoryItem = newValue;
                      });
                    },
                    items: _dropdownCategories.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(start: 20.w),
                          child: Text(
                            item,
                            style: const TextStyle(color: appThemeColor),
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Padding(
                      padding: EdgeInsetsDirectional.only(start: 20.w),
                      child: const Text('Select Category',
                          style: TextStyle(color: Color(0xffBDBDBD))),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xffBDBDBD),
                    ),
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
              child: Container(
                width: 1.sw,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Color(0xffF3F5F7)),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: 20.w),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedColorItem,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedColorItem = newValue;
                      });
                    },
                    items: _dropdownColor.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(start: 20.w),
                          child: Text(
                            item,
                            style: const TextStyle(color: appThemeColor),
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Padding(
                      padding: EdgeInsetsDirectional.only(start: 20.w),
                      child: const Text('Select Colour',
                          style: TextStyle(color: Color(0xffBDBDBD))),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xffBDBDBD),
                    ),
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
              child: Container(
                width: 1.sw,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Color(0xffF3F5F7)),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: 20.w),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedLostFoundItem,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedLostFoundItem = newValue;
                      });
                    },
                    items: _dropdownItemListed.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(start: 20.w),
                          child: Text(
                            item,
                            style: const TextStyle(color: appThemeColor),
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Padding(
                      padding: EdgeInsetsDirectional.only(start: 20.w),
                      child: const Text('Categorize',
                          style: TextStyle(color: Color(0xffBDBDBD))),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xffBDBDBD),
                    ),
                    underline: Container(
                      height: 0,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
              child: TextFormField(
                maxLines: 5,
                controller: _descriptionEditor,
                cursorColor: appThemeColor,
                inputFormatters: [
                  CustomFormatter(),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsetsDirectional.symmetric(
                      horizontal: 20.w, vertical: 10.h),
                  hintText: "Description",
                  filled: true,
                  fillColor: const Color(0xffF3F5F7),
                  hintStyle: const TextStyle(
                    color: Color(0xffBDBDBD),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffF3F5F7), // Border color
                      ),
                      borderRadius: BorderRadius.circular(8.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffF3F5F7), // Border color
                      ),
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                style: const TextStyle(color: appThemeColor),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
                padding: EdgeInsetsDirectional.only(start: 20.r, end: 20.r),
                width: 1.sw / 2,
                child: RoundedButton(
                    buttonText: "Upload",
                    onPressed: () {
                      checkConditions(context);
                    },
                    buttonColor: appThemeColor,
                    textColor: Colors.white,
                    shouldTextBold: false,
                    buttonTextSize: 16.sp)),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      )),
    );
  }

  Future<void> cameraPermission(context) async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      requestCameraPermision(context);
      print("Permission is denined.");
    } else if (status.isGranted) {
      //permission is already granted.
      showUploadBottomSheet(context);
      print("Permission is already granted.");
    } else if (status.isPermanentlyDenied) {
      //permission is permanently denied.
      // requestCameraPermision(context);
      AppConfig().displayInfo(context,
          "Phone has blocked camera permission.Please go to setting and grant it manually.");
      print("Permission is permanently denied");
    } else if (status.isRestricted) {
      //permission is OS restricted.
      requestCameraPermision(context);
      print("Permission is OS restricted.");
    } else {
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
      setState(() {
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
      setState(() {
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
                  child: RoundedButton(
                      buttonText: "Cancel",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      buttonColor: appThemeColor,
                      textColor: Colors.white,
                      shouldTextBold: false,
                      buttonTextSize: 16.sp),
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

  void checkConditions(BuildContext context) {
    if (image == null) {
      AppConfig().displayError(context, "please upload image");
    } else if (_nameEditor.text.isEmpty) {
      AppConfig().displayError(context, "Please Enter Name.");
    } else if (_addressEditor.text.isEmpty) {
      AppConfig().displayError(context, "Please Enter Address.");
    } else if (_durationEditor.text.isEmpty) {
      AppConfig().displayError(context, "Please Enter Time Duration.");
    } else if (_selectedCategoryItem == null) {
      AppConfig().displayError(context, "Please Choose Category.");
    } else if (_selectedColorItem == null) {
      AppConfig().displayError(context, "Please Choose Colour.");
    } else if (_selectedLostFoundItem == null) {
      AppConfig().displayError(context, "Please Choose Item is Lost Or Found.");
    } else if (_descriptionEditor.text.isEmpty) {
      AppConfig().displayError(context, "Please Enter Description.");
    } else {
      if (_selectedLostFoundItem == 'Lost') {
        registerInLostData();
      } else {
        registerInFoundData();
      }
    }
  }

  Future<void> registerInFoundData() async {
    EasyLoading.show();
    imageBase64 = await AppConfig().convertImageToBase64(image!);

    // Create a LostFoundItem object
    LostFoundItem newItem = LostFoundItem(
      userId: AppConfig().user!.uid,
      name: _nameEditor.text,
      address: _addressEditor.text,
      duration: _durationEditor.text,
      description: _descriptionEditor.text,
      category: _selectedCategoryItem!,
      color: _selectedColorItem!,
      imageUrl: imageBase64.toString(),
    );

    try {
      // Add the item to the "lost" collection in Firestore
      await FirebaseFirestore.instance.collection('found items').add({
        'user id': newItem.userId,
        'name': newItem.name,
        'address': newItem.address,
        'duration': newItem.duration,
        'description': newItem.description,
        'category': newItem.category,
        'color': newItem.color,
        'imageUrl': newItem.imageUrl,
      });
    } catch (e) {
      EasyLoading.dismiss();
      AppConfig().displayError(
          context, AppConfig().convertFirebaseErrorMessage(e.toString()));
    } finally {
      EasyLoading.dismiss();
    }
    AppConfig().displaySuccessDialog(context, "Item added successfully");
    clearAllFields();
  }

  void registerInLostData() async {
    EasyLoading.show();
    imageBase64 = await AppConfig().convertImageToBase64(image!);

    // Create a LostFoundItem object
    LostFoundItem newItem = LostFoundItem(
      userId: AppConfig().user!.uid,
      name: _nameEditor.text,
      address: _addressEditor.text,
      duration: _durationEditor.text,
      description: _descriptionEditor.text,
      category: _selectedCategoryItem!,
      color: _selectedColorItem!,
      imageUrl: imageBase64.toString(),
    );

    try {
      // Add the item to the "lost" collection in Firestore
      await FirebaseFirestore.instance.collection('lost items').add({
        'user id': newItem.userId,
        'name': newItem.name,
        'address': newItem.address,
        'duration': newItem.duration,
        'description': newItem.description,
        'category': newItem.category,
        'color': newItem.color,
        'imageUrl': newItem.imageUrl,
      });
    } catch (e) {
      EasyLoading.dismiss();
      AppConfig().displayError(
          context, AppConfig().convertFirebaseErrorMessage(e.toString()));
    } finally {
      EasyLoading.dismiss();
    }
    AppConfig().displaySuccessDialog(context, "Item added successfully");
    clearAllFields();
  }

  void clearAllFields() {
    setState(() {
      image = null;
      _nameEditor.text = '';
      _addressEditor.text = '';
      _durationEditor.text = '';
      _selectedCategoryItem = null;
      _selectedColorItem = null;
      _selectedLostFoundItem = null;
      _descriptionEditor.text = '';
    });
  }
}
