// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ChatListingScreen extends StatefulWidget {
//   const ChatListingScreen({super.key});

//   @override
//   State<ChatListingScreen> createState() => _ChatListingScreenState();
// }

// class _ChatListingScreenState extends State<ChatListingScreen> {
//   String _currentUserId = "5";

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: blackBoxColor,
//       appBar: PreferredSize(
//         preferredSize: Size(size.width, size.width * numD15),
//         child: CommonAppBarTitle(
//             func: () {
//               Navigator.pop(context);
//             },
//             shareActionFunc: () {},
//             dotActionFunc: () {},
//             favoriteActionFunc: () {},
//             color: tittleBarColor,
//             title: chatText,
//             isShare: false,
//             isDotMenu: false,
//             isLeading: true,
//             isFavorite: false),
//       ),
//       body: SafeArea(
//           child: Padding(
//         padding: EdgeInsets.symmetric(
//           vertical: size.width * numD045,
//           horizontal: size.width * numD03,
//         ),
//         child: chatUserList(size),
//       )),
//     );
//   }

//   Widget chatUserList(Size size) {
//     // var messages = FirebaseFirestore.instance.collection('Chat');

//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("Chat")
//           .orderBy('date', descending: true)
//           .snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
//         if (snapShot.hasError) {
//           return const Center(
//             child: Text('Something went wrong'),
//           );
//         }
//         if (snapShot.connectionState == ConnectionState.waiting) {
//           return Center(child: Container());
//         }
//         return snapShot.data!.docs.isNotEmpty
//             ? ListView(
//                 shrinkWrap: true,
//                 children: snapShot.data!.docs.map((DocumentSnapshot document) {
//                   if (document.get('sender_id').toString() ==
//                           _currentUserId.toString() ||
//                       document.get('receiver_id').toString() ==
//                           _currentUserId.toString()) {
//                     debugPrint("roomId${document.get('room_id')}");

//                     return InkWell(
//                       onTap: () {
//                         Map<String, dynamic> json = {
//                           "receiver_id": document.get('receiver_id') !=
//                                   _currentUserId.toString()
//                               ? document.get('receiver_id')
//                               : document.get('sender_id'),
//                           "receiver_pic": document.get('receiver_id') !=
//                                   _currentUserId.toString()
//                               ? document.get('receiver_pic')
//                               : document.get('sender_pic'),
//                           "receiver_name": document.get('receiver_id') !=
//                                   _currentUserId.toString()
//                               ? document.get('receiver_name')
//                               : document.get('sender_name'),
//                           "room_id": document.get('room_id'),
//                         };

//                         Navigator.push(
//                             globalContext,
//                             MaterialPageRoute(
//                                 builder: (context) => ChatConversationScreen(
//                                       roomDetail: json,
//                                     )));
//                         /*Navigator.push(context,
//                       MaterialPageRoute(
//                           builder: (context) => LiveChatScreen(
//                             roomId: document.get('roomId'),
//                             sender_name: _currentUserName.toString(),
//                             sender_pic: _currentUserProfilePic.toString(),
//                             sender_id: _currentUserId,
//                             receiver_id: document.get('receiver_id') != _currentUserId.toString()
//                                 ? document.get('receiver_id')
//                                 : document.get('sender_id'),
//                             receiver_pic: document.get('receiver_id') != _currentUserId.toString()
//                                 ? document.get('receiver_pic')
//                                 : document.get('sender_pic'),
//                             receiver_name: document.get('receiver_id') != _currentUserId.toString()
//                                 ? document.get('receiver_name')
//                                 : document.get('sender_name'),
//                           )));*/
//                       },
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Stack(
//                                 alignment: Alignment.bottomRight,
//                                 children: [
//                                   CircleAvatar(
//                                     radius: size.width * numD07,
//                                     backgroundImage: NetworkImage(
//                                         document.get('receiver_id') !=
//                                                 _currentUserId.toString()
//                                             ? document.get('receiver_pic')
//                                             : document.get('sender_pic')),
//                                   ),
//                                   /*Image.network(
//                               document.get(
//                                   'receiver_id') !=
//                                   _currentUserId
//                                       .toString()
//                                   ? document.get(
//                                   'receiver_pic')
//                                   :
//                               document.get(
//                                   'sender_pic'),
//                               width: size.width * numD13,
//                             ),*/
//                                   Container(
//                                     padding:
//                                         EdgeInsets.all(size.width * numD005),
//                                     decoration: const BoxDecoration(
//                                         color: whiteColor,
//                                         shape: BoxShape.circle),
//                                     child: CircleAvatar(
//                                       radius: size.width * numD012,
//                                       backgroundColor: /*state[index].status == onlineText
//                               ? darkGreenColor
//                               : */
//                                           greyOfflineChatColor,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: size.width * numD04,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CommonText(
//                                     title: document.get('receiver_id') !=
//                                             _currentUserId.toString()
//                                         ? document.get('receiver_name')
//                                         : document.get('sender_name'),
//                                     fontSize: numD04,
//                                     color: whiteColor,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                   SizedBox(
//                                     height: size.width * numD01,
//                                   ),
//                                   SizedBox(
//                                     width: size.width * numD50,
//                                     child: CommonText(
//                                         title: document.get("message_type") ==
//                                                 "text"
//                                             ? document.get('message')
//                                             : "Image",
//                                         fontSize: numD035,
//                                         color: accountEmailColor,
//                                         maxLine: 1,
//                                         overflow: TextOverflow.ellipsis),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           Divider(
//                             thickness: 1,
//                             height: size.width * numD08,
//                             color: whiteColor.withOpacity(.15),
//                           )
//                         ],
//                       ),
//                     );
//                   } else {
//                     return Container();
//                   }
//                 }).toList(),
//               )
//             : SizedBox(
//                 width: double.infinity,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SizedBox(
//                         height: MediaQuery.of(context).size.height / 3,
//                         width: MediaQuery.of(context).size.height / 3,
//                         child: Image.asset("assets/icons/chat.png")),
//                     const Text(
//                       "No Chat found!",
//                       style: TextStyle(
//                           fontSize: 25.0,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               );
//       },
//     );
//   }
// }
