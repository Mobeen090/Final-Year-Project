import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../appConfig.dart';
import '../../../constants/colors.dart';
import '../../../constants/routes.dart';
import '../../../models/lostAndfound_model.dart';
import '../../customWidgets/rounded_button.dart';

class FoundItemScreen extends StatefulWidget {
  @override
  State<FoundItemScreen> createState() => _FoundItemScreenState();
}

class _FoundItemScreenState extends State<FoundItemScreen> {
  final CollectionReference foundItems =
      FirebaseFirestore.instance.collection('found items');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('registered users');

  late Future<List<Map<String, dynamic>>> _futureItemsWithIDs;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureItemsWithIDs = _fetchItemsWithIDs();
  }

  Future<List<Map<String, dynamic>>> _fetchItemsWithIDs() async {
    QuerySnapshot querySnapshot = await foundItems.get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    List<Map<String, dynamic>> itemsWithIDs = [];

    for (DocumentSnapshot document in documents) {
      LostFoundItem item = LostFoundItem.fromFirestore(document);
      Map<String, dynamic> itemWithID = {
        'item': item,
        'documentID': document.id,
      };
      itemsWithIDs.add(itemWithID);
    }

    return itemsWithIDs;
  }

  List<Map<String, dynamic>> _searchItems(
      List<Map<String, dynamic>> items, String query) {
    return items.where((item) {
      return item['item'].category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
          ),
          onChanged: (query) {
            setState(() {
              _futureItemsWithIDs = _fetchItemsWithIDs();
            });
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureItemsWithIDs,
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(appThemeColor),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List<Map<String, dynamic>> itemsWithIDs = snapshot.data!;
          itemsWithIDs = _searchItems(itemsWithIDs, _searchController.text);

          return ListView.separated(
            itemCount: itemsWithIDs.length,
            separatorBuilder: (context, index) => SizedBox(height: 4.h),
            itemBuilder: (context, index) {
              LostFoundItem item = itemsWithIDs[index]['item'];
              String documentID = itemsWithIDs[index]['documentID'];
              return _buildListItem(item, documentID);
            },
          );
        },
      ),
    );
  }

  Widget _buildListItem(LostFoundItem item, String documentID) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(item.userId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.done) {
          if (userSnapshot.hasError) {
            return Text('Error: ${userSnapshot.error}');
          }

          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            Map<String, dynamic> userData =
                userSnapshot.data!.data() as Map<String, dynamic>;

            return Card(
              surfaceTintColor: Colors.white,
              color: Colors.white,
              elevation: 5.r,
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.all(8.r),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.memory(
                        AppConfig().convertImageByte(item.imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),
                        Text(
                          item.name.toString(),
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5.h),
                        _buildInfoRow(Icons.category, item.category.toString()),
                        SizedBox(height: 5.h),
                        _buildInfoRow(Icons.location_on_outlined,
                            item.address.toString()),
                        SizedBox(height: 5.h),
                        _buildInfoRow(
                            Icons.access_time, item.duration.toString()),
                        SizedBox(height: 15.h),
                        _buildUserDetails(userData),
                        SizedBox(height: 10.h),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: RoundedButton(
                              buttonText: "View Details",
                              onPressed: () {
                                navToItemDetailScreen(
                                    context, item, userData, documentID);
                              },
                              buttonColor: appThemeColor,
                              textColor: Colors.white,
                              shouldTextBold: false,
                              buttonTextSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('User not found'));
          }
        } else {
          return Center(child: Container());
        }
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22.r,
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(fontSize: 14.sp),
          overflow: TextOverflow.ellipsis,
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
          radius: 25.r,
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData['name'],
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                userData['phone'],
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void navToItemDetailScreen(BuildContext context, LostFoundItem item,
      Map<String, dynamic> userData, String documentID) {
    Navigator.pushNamed(
      context,
      Routes.itemDetailRoute,
      arguments: {
        'item': item,
        'userData': userData,
        'isFromFoundCategory': true,
        'documentID': documentID,
      },
    );
  }
}
