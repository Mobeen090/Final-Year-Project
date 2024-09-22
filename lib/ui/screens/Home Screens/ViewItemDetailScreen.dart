import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';
import '../../../appConfig.dart';
import '../../../constants/appImagePaths.dart';
import '../../../constants/colors.dart';
import '../../../models/lostAndfound_model.dart';
import '../../customWidgets/rounded_button.dart';
import 'ChatScreen.dart';

class ViewItemDetails extends StatefulWidget {
  const ViewItemDetails({super.key});

  @override
  State<ViewItemDetails> createState() => _ViewItemDetailsState();
}

class _ViewItemDetailsState extends State<ViewItemDetails> {
  Map<String, dynamic>? userData;
  LostFoundItem? item;
  bool? isFromFoundCategory;
  String? documentID;

  @override
  void initState() {
    super.initState();
    isFromFoundCategory=false;
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic>? arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      item  = arguments['item'] as LostFoundItem;
      userData = arguments['userData'] as Map<String, dynamic>;
      isFromFoundCategory=arguments['isFromFoundCategory'] as bool ;
      documentID = arguments['documentID'] ;
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
        iconSize: 32.r, // Adjust the size as needed
      ),iconTheme: IconThemeData(color: appThemeColor),centerTitle: true,
        title: Image.asset(AppImages.appLogo),),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.r),
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                GestureDetector(
                  onTap: ()=> _showImageAlertDialog(context,item!.imageUrl),child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Card(
                      elevation: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: SizedBox(
                          height: 250.r,
                          width: 1.sw,
                          child: Image(
                            fit: BoxFit.cover,
                            image: MemoryImage(
                              AppConfig().convertImageByte(item!.imageUrl),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsetsDirectional.only(start: 18.w,end: 20.w,top: 10.h),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(item!.name,style: TextStyle(color: Colors.black,fontSize: 22.sp,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 20.h,),
                      _buildInfoRow(Icons.location_on_outlined, item!.address.toString()),
                      SizedBox(height: 15.h,),
                      _buildInfoRow(Icons.access_time, item!.duration.toString()),
                      SizedBox(height: 15.h,),
                      _buildInfoRow(Icons.category, item!.category.toString()),
                      SizedBox(height: 15.h,),
                      Row(
                        children: [

                          Text("Colour : " ,style: TextStyle(color: Colors.black,fontSize: 20.sp,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                          Text(item!.color,style: TextStyle(color: Colors.grey,fontSize: 22.sp,fontWeight: FontWeight.normal),overflow: TextOverflow.ellipsis,),
                        ],
                      ),
                      SizedBox(height: 15.h,),
                      Material(
                        borderRadius: BorderRadius.circular(8.r),
                        elevation: 4,child: Container(
                        padding: EdgeInsetsDirectional.only(top: 8.h,start: 8.w,bottom: 8.r,end: 4.w),
                          width: 1.sw,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Description" ,style: TextStyle(color: Colors.black,fontSize: 22.sp,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                              Text(item!.description ,style: TextStyle(color: Colors.grey,fontSize: 18.sp,fontWeight: FontWeight.normal)),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25.h,),
                      _buildUserDetails(userData!),
                      SizedBox(height: 25.h,),
                      SizedBox(
                      width: 1.sw,child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          isFromFoundCategory == false ? RoundedButton(buttonText: "Track Item", onPressed: () async {
                            final availableMaps = await MapLauncher.installedMaps;
                            await availableMaps.first.showMarker(
                              coords: Coords(31.4469, 74.2682),
                              title: "University Of Central Punjab",
                            );
                            }, buttonColor: appThemeColor, textColor: Colors.white, shouldTextBold: true, buttonTextSize: 16.sp):Container(),
                          SizedBox(width:4.w),
                          RoundedButton(buttonText: "Let's Chat", onPressed: (){
                            navToChatScreen(context,item!,userData!,documentID!);
                          }, buttonColor: appThemeColor, textColor: Colors.white, shouldTextBold: true, buttonTextSize: 16.sp)

                        ],
                      ),
                    ),
                      SizedBox(height: 25.h,),

                    ],
                  )
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void navToChatScreen(BuildContext context,LostFoundItem item, Map<String, dynamic> userData, String documentID){

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  GroupChatScreen( documentID,)),
    );

  }

  void _showImageAlertDialog(BuildContext context, String? imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 1.sh,
            width: 1.sw,
            padding: EdgeInsetsDirectional.all(6.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),child: Image(
                fit: BoxFit.fill,
                image: MemoryImage(
                  AppConfig().convertImageByte(imageUrl!),
                ),
              ),
            ),
          ),
          actions: <Widget>[
        Align(
        alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close',style: TextStyle(color: appThemeColor,fontSize: 16.sp),),
          ),
        )
          ],
        );
      },
    );
  }

}

Widget _buildInfoRow(IconData icon, String text) {
  return Row(
    children: [
      Icon(
        icon,
        size: 35.r,
      ),
      SizedBox(width: 8.w),
      Expanded(
        child: Text(
          text,
          style: TextStyle(fontSize: 17.sp),
        ),
      ),
    ],
  );
}

Widget _buildUserDetails(Map<String, dynamic> userData) {
  return Row(
    children: [
      CircleAvatar(
        backgroundImage: MemoryImage(
          AppConfig().convertImageByte(userData['image']),
        ),
        radius: 40.r,
      ),
      Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userData['name'],
              style: TextStyle(fontSize: 18.sp, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              userData['phone'],
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
}
