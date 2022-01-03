import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/controllers/local_tree_controller.dart';
import 'package:kins_v002/view_model/main_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserViewModel(), permanent: true).getUserFromSharedPreferences();
    Get.put<LocalTreeController>(LocalTreeController(), permanent: true)
        .getAllUsers();
    return GetBuilder<MainViewModel>(
        init: Get.put(MainViewModel()),
        builder: (mainController) {
          Get.find<UserViewModel>();
          return Scaffold(
              bottomNavigationBar: _getBottomNavigationBar(),
              body: Scaffold(
                // appBar: AppBar(
                //   actions: [
                //     IconButton(
                //         onPressed: () {},
                //         icon: const Icon(
                //           Icons.notifications_none_outlined,
                //           color: Colors.grey,
                //         )),
                //     IconButton(
                //       icon: const Icon(
                //         Icons.chat_bubble_outline,
                //         color: primaryColor,
                //       ),
                //       onPressed: () {
                //         Get.to(ChatsScreen());
                //       },
                //     ),
                //     const SizedBox(width: 30)
                //   ],
                //   backgroundColor: Colors.white,
                //   elevation: 0,
                //   title: CustomText(
                //     text: 'Kins',
                //     color: Theme.of(context).primaryColor,
                //     size: 30,
                //   ),
                // ),
                body: mainController.currentScreen,
              ));
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
