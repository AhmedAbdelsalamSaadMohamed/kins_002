import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/controllers/local_tree_controller.dart';
import 'package:kins_v002/services/firebase/notification_firestore.dart';
import 'package:kins_v002/view/family_view.dart';
import 'package:kins_v002/view/public_view.dart';
import 'package:kins_v002/view/screens/map_screen.dart';
import 'package:kins_v002/view/screens/profile_screen.dart';
import 'package:kins_v002/view/screens/tree_screen.dart';
import 'package:kins_v002/view/social/notifications_tab.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/auth_view_model.dart';
import 'package:kins_v002/view_model/chat_view_model.dart';
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
        endDrawer: _drawer(),
        body: DefaultTabController(
          length: 3,
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
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 30,
                              ),
                              Positioned(
                                top: 0,
                                child: StreamBuilder<int>(
                                    stream:
                                        ChatViewModel().getNotSeenChatsCount(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError ||
                                          !snapshot.hasData ||
                                          snapshot.data == 0) {
                                        return Container();
                                      }
                                      return Align(
                                          alignment: Alignment.topLeft,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 9,
                                              child: Text(
                                                snapshot.data!.toString(),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              )));
                                      Chip(
                                        label: Text(
                                          snapshot.data!.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                        labelPadding: EdgeInsets.all(1),

                                        // decoration: BoxDecoration(
                                        //   color: Colors.red,
                                        //   borderRadius: BorderRadius.circular(20),
                                        // ),
                                        padding: EdgeInsets.all(2),
                                      );
                                    }),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Get.to(ChatsScreen());
                          },
                        ),
                      ],
                    ),
                    forceElevated: true,
                  ),
                  SliverAppBar(
                    title: TabBar(
                      labelColor: Colors.grey,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.public),
                        ),
                        Tab(
                          icon: Icon(Icons.family_restroom_rounded),
                        ),
                        Tab(
                          icon: Icon(Icons.person),
                        ),
                      ],
                      overlayColor: MaterialStateProperty.all(Colors.green),
                    ),
                    pinned: true,
                    leadingWidth: 0,
                  )
                ];
              },
              body: TabBarView(
                children: [PublicView(), FamilyView(), ProfileScreen()],
              )),
        ),
        floatingActionButton: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            HttpsCallable callable =
                FirebaseFunctions.instance.httpsCallable('changeId');
            callable.call(<String, dynamic>{
              "old": "oldId",
              "new": "newId",
            });
            print('result = {resp.data}');
          },
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: ProfileCircleAvatar(
                imageUrl: userController.currentUser!.profile!,
                radius: 20,
                gender: userController.currentUser!.gender),
            title: CustomText(
              text: userController.currentUser!.name!,
            ),
            onTap: () => Get.to(ProfileScreen()),
          ),
          Divider(),
          ListTile(
            title: Text('Family Tree'),
            trailing: Icon(Icons.account_tree_rounded),
            onTap: () {
              Get.to(TreeScreen());
            },
          ),
          ListTile(
            title: Text('Family Map'),
            trailing: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.account_tree_rounded),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(Icons.account_tree_rounded),
                )
              ],
            ),
            onTap: () {
              Get.to(MapScreen());
            },
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
    );
  }
}
