// import 'dart:convert';
//
// import 'package:kins_v002/model/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPreferencesService {
//   final String _userKey = 'user';
//   final String _isDarkKey = 'isDark';
//   final String _languageKey = 'language';
//
//   Future<bool> addUser(UserModel user) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(_userKey, json.encode(user.toJson()));
//   }
//
//   Future<UserModel?> getUser() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? result = prefs.getString(_userKey);
//     if (result == null) {
//       return null;
//     } else {
//       return UserModel.fromJson(json.decode(result));
//     }
//   }
//
//   Future<bool> deleteUser() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.remove(_userKey);
//   }
//
//   Future<bool> setDarkMode(bool isDark) async {
//     return SharedPreferences.getInstance()
//         .then((value) => value.setBool(_isDarkKey, isDark));
//   }
//
//   Future<bool?> getDarkMode() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(_isDarkKey);
//   }
//
//   Future<bool> setLanguage(String language) async {
//     return SharedPreferences.getInstance()
//         .then((value) => value.setString(_languageKey, language));
//   }
//
//   Future<String?> getLanguage() async {
//     return SharedPreferences.getInstance()
//         .then((value) => value.getString(_languageKey));
//   }
// }
