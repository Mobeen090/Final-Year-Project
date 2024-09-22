import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../appConfig.dart';
import '../../../constants/appImagePaths.dart';
import '../../../constants/colors.dart';

class GroupChatScreen extends StatefulWidget {
  final String? lostItemId;

  GroupChatScreen(this.lostItemId);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 32.r,
        ),
        iconTheme: IconThemeData(color: appThemeColor),
        centerTitle: true,
        title: Image.asset(AppImages.appLogo),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _fetchGroupChatMessages(),
              builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appThemeColor) ,),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                var groupChatMessages = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: groupChatMessages.length,
                  itemBuilder: (context, index) {
                    var message = groupChatMessages[index];
                    return Padding(
                      padding:  EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUserAvatar(message['sender']),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['sender'] ?? 'Unknown Sender',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.h),
                                Text(message['text'] ?? ''),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.all(8.r),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(String? senderName) {
    return CircleAvatar(
      radius: 20.r,
      backgroundColor: appThemeColor,
      child: Text(
        senderName != null && senderName.isNotEmpty ? senderName[0] : '?',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _fetchGroupChatMessages() {
    var groupChatStream = _firestore
        .collection('group_chat_messages')
        .doc(widget.lostItemId!)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();

    return groupChatStream.map((event) {
      var data = event.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      print(data); // Add this line to check the data
      return data;
    })..map((groupChatMessages) {
      groupChatMessages.sort((a, b) =>
          (a['timestamp'] as Timestamp).compareTo(b['timestamp'] as Timestamp));
      return groupChatMessages;
    });
  }

  void _sendMessage() {
    String text = _textController.text.trim();

    if (text.isNotEmpty) {
      _firestore
          .collection('group_chat_messages')
          .doc(widget.lostItemId!)
          .collection('messages')
          .add({
        'text': text,
        'sender': AppConfig().user!.displayName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _textController.clear();
    }
  }
}
