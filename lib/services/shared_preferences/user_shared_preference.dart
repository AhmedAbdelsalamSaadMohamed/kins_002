// import 'dart:convert';
//
// import 'package:kins_v002/model/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserSharedPreferences {
//   setUserToSharedPreferences(UserModel user) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user', json.encode(user.toJson()));
//
//   }
//
//   Future<UserModel?> getUserFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? user = prefs.getString('user');
//     if (user != null) {
//       return UserModel.fromJson(json.decode(user));
//     } else {
//       return null;
//     }
//   }
//
//   deleteUserFromSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('user');
//   }
// }
