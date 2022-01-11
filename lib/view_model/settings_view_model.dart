// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kins_v002/services/shared_preferences/shared_preferences_service.dart';
// import 'package:kins_v002/utils/themes/dark_theme.dart';
// import 'package:kins_v002/utils/themes/light_theme.dart';
//
//
// class SettingsViewModel extends GetxController {
//   RxBool isDark = false.obs;
//   RxString language = 'ar'.obs;
//
//   final SharedPreferencesService _sharedPreferencesService =
//       SharedPreferencesService();
//
//   @override
//   Future<void> onInit() async {
//     isDark.value = (await _sharedPreferencesService.getDarkMode()) ?? Get.isPlatformDarkMode;
//     language.value = (await _sharedPreferencesService.getLanguage()) ??
//         Get.deviceLocale!.languageCode;
//     super.onInit();
//   }
//
//   changeTheme(bool newValue) {
//     Get.changeTheme(newValue ? darkTheme : lightTheme);
//     _sharedPreferencesService.setDarkMode(newValue).then((done) {
//       // if (done)
//       {
//         isDark.value = (newValue);
//         Get.changeTheme(newValue ? darkTheme : lightTheme);
//         update();
//       }
//     });
//   }
//
//   changeLanguage(String newLanguage) {
//     _sharedPreferencesService.setLanguage(newLanguage).then((done) {
//       if (done) {
//         language.value = newLanguage;
//         Get.updateLocale(Locale(newLanguage));
//         update();
//       }
//     });
//   }
//  Future<String> getLanguage() async {
//     return (await _sharedPreferencesService.getLanguage()) ??
//     Get.deviceLocale!.languageCode;
//   }
// }
