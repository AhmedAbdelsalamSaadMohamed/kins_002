import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/services/firebase/notification_firestore.dart';
import 'package:kins_v002/services/firebase/post_firestore.dart';
import 'package:kins_v002/view/screens/chats_screen.dart';
import 'package:kins_v002/view/screens/profile_screen.dart';
import 'package:kins_v002/view/social/notifications_tab.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/new_post_wiget.dart';
import 'package:kins_v002/view/widgets/post_widget.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/auth_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class HomeTap extends StatelessWidget {
  HomeTap({Key? key}) : super(key: key);
  UserViewModel userController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProfileCircleAvatar(
              imageUrl: userController.currentUser!.profile!,
              radius: 20,
              gender: userController.currentUser!.gender),
        ),
        elevation: 0,
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
                    stream: NotificationFireStore().getNotificationsStream(
                        Get.find<UserViewModel>().currentUser!.id!),
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
                                snapshot.data!.docs.length.toString(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
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
      ),
      body: FutureBuilder<Query>(
          future: PostFireStore().getRecommendedPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error...'),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Query query = snapshot.data!;
              return RefreshIndicator(
                onRefresh: () async {
                  PostFireStore()
                      .getRecommendedPosts()
                      .then((value) => query = value);
                  //return PostFireStore().getRecommendedPosts();
                },
                child: PaginateFirestore(
                  itemBuilder: (int index, BuildContext context,
                      DocumentSnapshot documentSnapshot) {
                    if (index == 0) {
                      return Column(
                        children: [
                          NewPostWidget(
                            showProfile: true,
                          ),
                          PostWidget(
                            postId: documentSnapshot.id,
                          ),
                        ],
                      );
                    } else {
                      return PostWidget(
                        postId: documentSnapshot.id,
                      );
                    }
                  },
                  query: query,
                  itemBuilderType: PaginateBuilderType.listView,
                  itemsPerPage: 4,
                  padding: const EdgeInsets.only(bottom: 150),
                  emptyDisplay: NewPostWidget(),
                  shrinkWrap: true,
                ),
              );
            }
          }),
    );
  }
}
