import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/view_model/main_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class FamilyTab extends StatelessWidget {
  const FamilyTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainViewModel>(
        init: Get.put(MainViewModel()),
        builder: (mainController) {
          Get.find<UserViewModel>();
          return Scaffold(
            bottomNavigationBar: _getBottomNavigationBar(),
            body: mainController.currentScreen,
          );
        });
  }

  _getBottomNavigationBar() {
    return GetBuilder<MainViewModel>(
        init: Get.put(MainViewModel(), permanent: true),
        builder: (mainController) {
          return BottomNavigationBar(
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_tree,
                  //  color: primaryColor,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.map,
                  //color: primaryColor,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.group,
                  //color: primaryColor,
                ),
                label: '',
              ),
            ],
            currentIndex: mainController.navigatorValue,
            onTap: (value) {
              mainController.changeNavigatorValue(value);
            },
          );
        });
  }
}
