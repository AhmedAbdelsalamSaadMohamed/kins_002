import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/view/screens/chats_screen.dart';
import 'package:kins_v002/view/screens/profile_screen.dart';
import 'package:kins_v002/view/social/home_tab.dart';
import 'package:kins_v002/view/social/kins_tab.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/auth_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class SocialScreenn extends StatelessWidget {
  SocialScreenn({Key? key}) : super(key: key);
  final UserViewModel userController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: false,
              forceElevated: true,
              backgroundColor: Colors.white,
              elevation: 0,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                title: SizedBox(
                  height: 50,
                  child: TabBar(
                    overlayColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    indicatorColor: primaryColor,
                    tabs: const [
                      Tab(
                        icon: Icon(
                          Icons.home_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      Tab(
                          icon: Icon(
                        Icons.group_outlined,
                        color: Colors.grey,
                      )),
                    ],
                  ),
                ),
                background: Column(
                  children: [
                    AppBar(
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProfileCircleAvatar(
                            imageUrl: userController.currentUser!.profile!,
                            radius: 20,
                            gender: userController.currentUser!.gender),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_none_outlined,
                              color: Colors.grey,
                            )),
                        IconButton(
                          icon: const Icon(
                            Icons.chat_bubble_outline,
                            color: primaryColor,
                          ),
                          onPressed: () {
                            Get.to(ChatsScreen());
                          },
                        ),
                        const SizedBox(width: 50)
                      ],
                      backgroundColor: Colors.white,
                      elevation: 0,
                      title: CustomText(
                        text: 'Kins',
                        color: primaryColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
                titlePadding: EdgeInsets.all(0),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: TabBarView(physics: ScrollPhysics(), children: [
                  HomeTap(),
                  KinsTab(),
                ]),
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
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
                      title: const Text('Dark Mode'),
                      trailing: Switch(
                          value: userController.darkMode,
                          onChanged: (value) {
                            userController.setDarkMode(value);
                          }),
                    );
                  }),
              ListTile(
                title: Text('Settings'.tr),
                trailing: const Icon(Icons.settings),
                onTap: () {},
              ),
              Expanded(
                child: Container(),
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
      ),
    );
  }
}
