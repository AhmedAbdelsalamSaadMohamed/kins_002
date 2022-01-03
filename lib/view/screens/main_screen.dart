import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/controllers/local_tree_controller.dart';
import 'package:kins_v002/services/firebase/notification_firestore.dart';
import 'package:kins_v002/view/family_tab.dart';
import 'package:kins_v002/view/public_tab.dart';
import 'package:kins_v002/view/screens/profile_screen.dart';
import 'package:kins_v002/view/social/notifications_tab.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/auth_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

import 'chats_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  UserViewModel userController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    Get.put(UserViewModel(), permanent: true).getUserFromSharedPreferences();
    Get.put<LocalTreeController>(LocalTreeController(), permanent: true)
        .getAllUsers();
    return SafeArea(
      child: Scaffold(
        endDrawer: Drawer(
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                leading: ProfileCircleAvatar(
                    imageUrl: userController.currentUser!.profile!,
                    radius: 20,
                    gender: userController.currentUser!.gender),
                title: CustomText(
                  text: userController.currentUser!.name!,
                ),
                onTap: () =>
                    Get.to(ProfileScreen(user: userController.currentUser!)),
              ),
              Divider(),
              GetBuilder(
                  init: Get.find<UserViewModel>(),
                  builder: (controller) {
                    return ListTile(
                      title: Text('Dark Mode'.tr),
                      trailing: Switch(
                          value: userController.darkMode,
                          onChanged: (value) {
                            userController.setDarkMode(value);
                          }),
                    );
                  }),
              GetBuilder(
                  init: Get.find<UserViewModel>(),
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButton<String>(
                          value: userController.language,
                          onChanged: (value) {
                            userController.setLanguage(value!);
                          },
                          items: [
                            DropdownMenuItem(
                              child: Text('English'),
                              value: 'en',
                            ),
                            DropdownMenuItem(
                              child: Text('العربيه'),
                              value: 'ar',
                            )
                          ]),
                    );
                  }),
              ListTile(
                title: Text('Settings'.tr),
                trailing: const Icon(Icons.settings),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                title: Text('Sign Out'.tr),
                trailing: const Icon(Icons.logout),
                onTap: () => Get.put(AuthViewModel()).signOut(),
              ),
            ],
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    actions: <Widget>[Container()],
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ProfileCircleAvatar(
                          imageUrl: userController.currentUser!.profile!,
                          radius: 20,
                          gender: userController.currentUser!.gender),
                    ),
                    elevation: 0,
                    pinned: false,
                    floating: true,
                    snap: true,
                    title: Row(
                      children: [
                        CustomText(
                          text: 'Kins',
                          color: primaryColor,
                          size: 40,
                        ),
                        Expanded(child: Container()),
                        IconButton(
                          onPressed: () {
                            Get.to(NotificationsTab());
                          },
                          icon: Stack(children: [
                            const Icon(
                              Icons.notifications_none_outlined,
                              size: 30,
                            ),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: NotificationFireStore()
                                    .getNotificationsStream(
                                        Get.find<UserViewModel>()
                                            .currentUser!
                                            .id!),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData || snapshot.hasError) {
                                    return Container();
                                  }
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Container();
                                  }
                                  return Align(
                                      alignment: Alignment.topLeft,
                                      child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 9,
                                          child: Text(
                                            snapshot.data!.docs.length
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          )));
                                }),
                          ]),
                        ),
                        IconButton(
                          icon: Stack(
                            children: const [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 30,
                              ),
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //   child: CircleAvatar(
                              //     backgroundColor: Colors.red,
                              //     radius: 9,
                              //     child: Text(
                              //       '',
                              //       textAlign: TextAlign.center,
                              //       overflow: TextOverflow.ellipsis,
                              //       style: TextStyle(fontSize: 12, color: Colors.white),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          onPressed: () {
                            Get.to(ChatsScreen());
                          },
                        ),
                      ],
                    ),
                    forceElevated: true,

                    // expandedHeight: 120,
                  ),
                  SliverAppBar(
                    title: TabBar(
                      labelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: 'home',
                        ),
                        Tab(
                          text: 'Family',
                        ),
                      ],
                      overlayColor: MaterialStateProperty.all(Colors.green),
                    ),
                    actions: [],
                    pinned: true,
                  )
                ];
              },
              body: TabBarView(
                children: [PublicTab(), FamilyTab()],
              )),
        ),
      ),
    );
  }
}
