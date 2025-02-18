//  * Flutter Imports * //
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//  * Third Party Imports * //

//  * Custom Imports * //

class ChatScreen extends StatefulWidget {
  //  * Parameters * //

  //  * Constructor * //
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //  * Variables * //

  TextEditingController messageController = TextEditingController();

  String senderId = "1";
  String senderName = "Webi tekk";
  String senderProfilePic =
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
  String receiverId = "";
  String receiverName = "dummy";
  String receiverProfilePic = "no";
  String roomId = "0000-0000-0000-0000";
  int dotPos = 0;

  void initializeReceiver() {
    receiverId = "10";
    receiverName = "anuj";
    receiverProfilePic = "";
    roomId = "52";
    addOnlineOffline(true);
  }

  void addOnlineOffline(bool isOnline) {
    debugPrint("OnLine ::: $isOnline");
    FirebaseFirestore.instance.collection('OnlineOffline').get().then((value) {
      debugPrint("OnlineOfflineData ::: $value");
      if (value.size == 0 || value.size > 0) {
        debugPrint("InsideAddOnLine--Add ::: ");
        FirebaseFirestore.instance
            .collection('OnlineOffline')
            .doc(senderId)
            .set({
          'isOnline': isOnline,
          'last_seen': DateTime.now().toUtc(),
          'userName': senderName,
          'room_id': roomId,
          "id": senderId,
          'senderImage': senderProfilePic,
        });
      } else {
        debugPrint("InsideAddOnLine--Update :::${value.size}");
        FirebaseFirestore.instance
            .collection('OnlineOffline')
            .doc(senderId)
            .update({
          'isOnline': isOnline,
          'last_seen': DateTime.now().toUtc(),
          'userName': senderName,
          'room_id': roomId,
          "id": senderId,
          'senderImage': senderProfilePic,
        });
      }
    });
  }

  Future<bool> checkReceiverActive() async {
    var data = FirebaseFirestore.instance
        .collection('OnlineOffline')
        .doc(receiverId)
        .snapshots();

    if (await data.length > 0) {
      var value = await data.first;
      debugPrint(
          "User Current Active In Room : ${value.get("room_id") != roomId && !value.get("isOnline")}");
      return value.get("room_id") != roomId && !value.get("isOnline");
    }

    return false;
  }

  void commonValues({
    required String messageType,
    required String messageInput,
    String thumbnailPath = "",
    int isReply = 0,
  }) async {
    debugPrint("::::: Inside Common Values ::::::::::");

    String messageId = DateTime.now().toUtc().millisecondsSinceEpoch.toString();

    Map<String, dynamic> map = {
      'message_id': messageId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_pic': senderProfilePic,
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'receiver_pic': receiverProfilePic,
      'room_id': roomId,
      'message_type': messageType,
      'message': messageInput,
      'document_type':
          messageType == "document" ? messageInput.split(".").last : "",
      'video_thumbnail': thumbnailPath,
      'date': DateTime.now()
          .toUtc()
          .toIso8601String()
          .toString() /*dateTimeFormatter(
          dateTime: ,
          format: "yyyy-MM-dd HH:mm:ss",
          utc: true)*/
      ,
      'uploadPercent': 0.0,
      /* 'read_status': "unread",
      'reply_type': "text",
      'latitude': 0.0,
      'longitude': 0.0,
      'isReply': isReply,
      'reply_message': "",*/
    };

    debugPrint("Map ==== > $map");

    uploadChatNew(map);

    // if (messageType == "text" && await checkReceiverActive()) {
    //   callSendNotificationAdminApi(body: messageInput);
    // } else if (await checkReceiverActive()) {
    //   callSendNotificationAdminApi(body: messageType);
    // }
  }

  Future<void> uploadChatNew(Map<String, dynamic> data) async {
    DocumentReference docReference = FirebaseFirestore.instance
        .collection('Chat')
        .doc(roomId)
        .collection('Messages')
        .doc();

    debugPrint("::::: Inside Upload Chat New ::::::::::");

    DocumentReference roomDetails =
        FirebaseFirestore.instance.collection('Chat').doc(roomId);

    await docReference.set(data);

    await roomDetails.set(data);
  }

  //  * Functions * //

  //  * Overrides * //

  @override
  void dispose() {
    addOnlineOffline(false);
    super.dispose();
  }

  //  * Build * //
  @override
  Widget build(BuildContext context) {
    var messages = FirebaseFirestore.instance
        .collection('Chat')
        .doc(roomId)
        .collection('Messages');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Chat App"),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: messages.orderBy('date', descending: true).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
              if (snapShot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(15),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  var document = snapShot.data!.docs[index];
                  return Column(
                    children: [
                      if (document.get("message_type") == "text")
                        document.get('sender_id') != senderId
                            ? showLeftChat(document)
                            : showRightChat(document),
                    ],
                  );
                },
                reverse: true,
                shrinkWrap: true,
                itemCount:
                    snapShot.data != null ? snapShot.data!.docs.length : 0,
              );
            },
          )),
          Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ]),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                      onTap: () {
                        debugPrint(
                            "Time :::: ${DateTime.now().toUtc().toIso8601String().toString()}");
                        if (messageController.text.isNotEmpty) {
                          commonValues(
                              messageType: "text",
                              messageInput: messageController.text);
                          messageController.clear();
                        }
                      },
                      child: Container(
                          height: 45,
                          width: 40,
                          color: Colors.black,
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.send,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          )),
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 10, left: 20),
                    hintText: "write message",
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //....
  ///
  /// ** Custom Widgets **
  ///
  //....

  Widget showLeftChat(
    QueryDocumentSnapshot<Object?> document,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.all(
          8,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 8,
        ),
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                8,
              ),
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(
                8,
              ),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(document.get('receiver_name')),
            SizedBox(
              height: 2,
            ),
            Text(document.get('message')),
          ],
        ),
      ),
    );
  }

  Widget showRightChat(
    QueryDocumentSnapshot<Object?> document,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.all(
          8,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.orange.shade300,
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(document.get('sender_name')),
            SizedBox(
              height: 4,
            ),
            Text(document.get('message')),
          ],
        ),
      ),
    );
  }
}
