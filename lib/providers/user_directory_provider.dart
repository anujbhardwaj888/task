// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hastar/api/api_class.dart';
// import 'package:hastar/haster.dart';
// import 'package:user_directory_offsureit_assignment/api/api_url.dart';
// import 'package:user_directory_offsureit_assignment/configs/constant.dart';
// import 'package:user_directory_offsureit_assignment/configs/helper.dart';
// import 'package:user_directory_offsureit_assignment/models/user_directory_model.dart';

// class UserDirectoryProvider extends GetxController with ApiClass {
//   //  * Variables * //

//   RxBool isLoading = false.obs;

//   final RxList<UserDirectoryModel> userDirectoryList =
//       RxList<UserDirectoryModel>([]);

//   final RxList<UserDirectoryModel> userDirectorySearchList =
//       RxList<UserDirectoryModel>([]);

//   final TextEditingController searchController = TextEditingController();

//   RxString searchText = "".obs;

//   /// * Constructors * ///
//   UserDirectoryProvider();

//   Future<void> setUserDirectoryListData(List data) async {
//     userDirectoryList.value =
//         data.map((e) => UserDirectoryModel.fromJson(e)).toList();
//   }

//   //setter

//   //  * Functions * //

//   Future<ApiResponseClass> getUserDirectoryListData() async {
//     ApiResponseClass responseData = ApiResponseClass();
//     try {
//       await httpGet(
//         url: GApiUrl().getUserDirectoryListUrl,
//         header: {
//           Constants().accept: Constants().applicationJson,
//           Constants().contentType: Constants().applicationJson,
//         },
//       ).then((response) {
//         responseData.status = response.statusCode;
//         responseData.body = jsonDecode(response.body);
//       });
//     } catch (e) {
//       responseData.body = {Constants().error: e};
//       responseData.status = ApiCode.status000;
//     }
//     return responseData;
//   }

//   Future<void> getQueryList() async {
//     isLoading.value = true;
//     await getUserDirectoryListData().then((response) async {
//       if (response.status == ApiCode.status200) {
//         isLoading.value = false;
//         await setUserDirectoryListData(response.body);
//       } else {
//         isLoading.value = false;
//         gToaster(text: Helper().statusCodeError(response.status));
//       }
//     });
//   }

//   void onsearch(String value) {
//     userDirectorySearchList.clear();
//     for (var element in userDirectoryList) {
//       if (element.name != null && element.name!.contains(value) ||
//           element.email != null && element.email!.contains(value)) {
//         userDirectorySearchList.add(element);
//       }
//     }

//     debugPrint(
//         '---userDirectorySearchList---->${userDirectorySearchList.length}');
//   }
// }
