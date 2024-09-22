import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../appConfig.dart';
import '../../constants/appImagePaths.dart';
import '../../constants/colors.dart';
import '../../constants/routes.dart';
import '../screens/Home Screens/FoundItemScreen.dart';
import '../screens/Home Screens/LostItemScreen.dart';
import '../screens/Home Screens/Profile.dart';
import '../screens/Home Screens/add_Item_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  _BottomNavigationScreenState createState() =>
      _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  String? image;
  String? name='';
  String? email='';
  String? phone='';
  late List<int> imageBytes;

  int _selectedTab = 2;

  final List<Widget> _pages = [
    FoundItemScreen(),
    LostItemScreen(),
    AddItemScreen(),
    ProfileScreen(),
  ];

  void _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }


  @override
  void initState() {
    super.initState();
    fetchData();

  }

  Future<void> fetchData() async {
    EasyLoading.show();
    try {
      // Replace 'your_collection' with the actual name of your Firestore collection
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('registered users').doc(_auth.currentUser!.uid).get();

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
    return WillPopScope(
        onWillPop: () async {
          _showExitConfirmationDialog(context);
          return false; // Prevent default back press behavior
        },
      child:
      Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(AppImages.appLogo),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundImage: image != null ? Image.memory(Uint8List.fromList(imageBytes)).image : const AssetImage(AppImages.iconAvatar),
                  ),
                  SizedBox(height: 10.r),
                  Text(
                    name??'',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                  Text(
                    email??'',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.search,color: appThemeColor,),
              title: Text('Found Items'),
              onTap: () {
                Navigator.pop(context);
                _changeTab(0);
              },
            ),
            ListTile(
              leading: Image.asset(
                AppImages.iconLost,
                height: 25.r,
                width: 25.r,
                color: appThemeColor,
              ),
              title: Text('Lost Items'),
              onTap: () {
                Navigator.pop(context);
                _changeTab(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.add,color: appThemeColor),
              title: Text('Add Item'),
              onTap: () {
                Navigator.pop(context);
                _changeTab(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.feed_outlined,color: appThemeColor),
              title: Text('Terms And Condition'),
              onTap: () {
                Navigator.pop(context);
              navToTermsAndCondition(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person,color: appThemeColor),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _changeTab(3);
              },
            ),

            ListTile(
              leading: Icon(Icons.logout,color: appThemeColor),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                AppConfig().displayInfo(context,"Are you sure you want to logout...?");
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedTab],
      bottomNavigationBar: Material(
        color: Colors.transparent,
        elevation: 8.r, // Set the elevation here
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedTab,
            onTap: (index) => _changeTab(index),
            selectedItemColor: appThemeColor,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: _selectedTab == 0
                    ? Image.asset(
                  AppImages.iconFound,
                  height: 25.r,
                  width: 25.r,
                  color: appThemeColor,
                )
                    : Image.asset(
                  AppImages.iconFound,
                  height: 25.r,
                  width: 25.r,
                ),
                label: "Found",
              ),
              BottomNavigationBarItem(
                icon: _selectedTab == 1
                    ? Image.asset(
                  AppImages.iconLost,
                  height: 25.r,
                  width: 25.r,
                  color: appThemeColor,
                )
                    : Image.asset(
                  AppImages.iconLost,
                  height: 25.r,
                  width: 25.r,
                ),
                label: "Lost",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add, size: 30.r),
                label: "Add",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30.r),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void navToTermsAndCondition(BuildContext context) {
    Navigator.pushNamed(context, Routes.termsAndConditionScreenRoute);
  }


  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit App'),
          content: Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog and do not exit
              },
              child: Text('No',style: TextStyle(color: appThemeColor),),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop(); // Close the dialog and exit the app
              },
              child: Text('Yes',style: TextStyle(color: appThemeColor),),
            ),
          ],
        );
      },
    );
  }

}
