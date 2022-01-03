// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:kins_v002/model/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthController extends GetxController {
//   AuthController() {
//     _getUserFromSharedPreferences();
//   }
//
//   UserModel? currentUser;
//
//   Future setUserToSharedPreferences(UserModel user) async {
//     currentUser = user;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs
//         .setString('user', json.encode(user.toJson()))
//         .whenComplete(() => update());
//   }
//
//   _getUserFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userCode = prefs.getString('user');
//     if (userCode != null) {
//       currentUser = UserModel.fromJson(json.decode(userCode));
//     } else {
//       currentUser = null;
//     }
//   }
//
//   deleteUserFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('user');
//   }
//   clearSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
//
// }
