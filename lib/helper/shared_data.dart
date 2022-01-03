// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kins_v002/controllers/auth_controller.dart';
// import 'package:kins_v002/model/user_model.dart';
// import 'package:kins_v002/services/firebase/user_firestore.dart';
// import 'package:kins_v002/services/shared_preferences/user_shared_preference.dart';
// import 'package:kins_v002/services/sqflite/user_sqflite_controller.dart';
// import 'package:kins_v002/services/sqflite/user_sqflite_database.dart';
// import 'package:kins_v002/view_model/user_view_model.dart';
//
// class SharedData {
//   static SharedData data = SharedData._();
//
//   SharedData._() {
//     //getUserSharedPreferencesData();
//
//
//   }
//
//   ValueNotifier<bool> _loading = ValueNotifier<bool>(false);
//
//   String? profileImageUrl=Get.find<AuthController>().currentUser!.profile;
//   String? id = Get.find<AuthController>().currentUser!.id;
//   String? name= Get.find<AuthController>().currentUser!.name;
//   String? email = Get.find<AuthController>().currentUser!.email;
//   late String headOfDadTree;
//   List<String> dadBranch = [];
//   List<UserModel> users = [];
//
//   // getUserSharedPreferencesData() async {
//   //   _loading.value = true;
//   //   Get.find<AuthController>().currentUser;
//   //   return await .u {
//   //     if (value != null) {
//   //       profileImageUrl = value.profile;
//   //       name = value.name;
//   //       email = value.email;
//   //       id = value.id;
//   //       _loading.value = false;
//   //       getHeadOfDadTree(id!);
//   //     }
//   //   });
//   }
//
//   getHeadOfDadTree(String id) async {
//     dadBranch.add(id);
//     String? dadId = await UserViewModel().getUserData(id).then((value) {
//       if (value == null) {
//         return null;
//       }
//       return value.dad;
//     });
//     if (dadId == null) {
//       headOfDadTree = id;
//       getUsers(headOfDadTree);
//     } else {
//       await getHeadOfDadTree(dadId);
//     }
//   }
//
//   getUsers(String dadId) async {
//     UserModel user = (await UserFirestore().getUserFromFirestore(dadId))!;
//     users.add(user);
//     if (user.spouse != null) {
//       UserModel spouse =
//           (await UserFirestore().getUserFromFirestore(user.spouse!))!;
//
//       users.add(spouse);
//     }
//     List<UserModel?> sons = await UserFirestore().getSonsFromFirestore(dadId);
//     if (sons.isNotEmpty) {
//       for (var element in sons) {
//         //UserModel son = element;
//         getUsers(element!.id!);
//       }
//     }
//   }
//
//
// }
