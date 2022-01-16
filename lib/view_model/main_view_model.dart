import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kins_v002/view/screens/family_members_screen.dart';
import 'package:kins_v002/view/screens/map_screen.dart';
import 'package:kins_v002/view/screens/tree_screen.dart';
import 'package:kins_v002/view/social/home_tab.dart';

class MainViewModel extends GetxController {
  int navigatorValue = 0;
  Widget currentScreen = HomeTap();

  void changeNavigatorValue(int selectedValue) {
    navigatorValue = selectedValue;
    switch (navigatorValue) {
      case 0:
        currentScreen = HomeTap();
        update();
        break;
      case 1:
        currentScreen = TreeScreen();
        update();
        break;
      case 2:
        currentScreen = MapScreen();
        update();
        break;
      case 3:
        currentScreen = FamilyMembersScreen();
        update();
        break;
    }
  }
}
