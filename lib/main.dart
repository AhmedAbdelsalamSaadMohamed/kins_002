import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/themes.dart';
import 'package:kins_v002/view/screens/main_screen.dart';
import 'package:kins_v002/view/screens/sign_in_screen.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

import 'utils_langs/translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          projectId: 'kins-25271',
          apiKey: 'AIzaSyBnjDFLSPMtzGZhPb2cPo_0gV1AmP6XaFM',
          messagingSenderId: '1042700768431',
          appId: '1:1042700768431:android:24eb49d273a1e0c65cb05a'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserViewModel>(
        init: Get.put(UserViewModel(), permanent: true),
        builder: (userController) {
          userController.getDarkMode();
          return FutureBuilder<String>(
              future: userController.getLanguage(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GetMaterialApp(
                  title: 'Kins'.tr,
                  smartManagement: SmartManagement.keepFactory,
                  debugShowCheckedModeBanner: false,
                  translations: Translation(),
                  locale: Locale(snapshot.hasData
                      ? snapshot.data!
                      : userController.language),
                  fallbackLocale: const Locale('en'),
                  theme: userController.darkMode ? Themes.dark : Themes.light,
                  home: userController.loading
                      ? const Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : userController.currentUser != null
                          ? MainScreen()
                          : SignInScreen(),
                );
              });
        });
  }
}
