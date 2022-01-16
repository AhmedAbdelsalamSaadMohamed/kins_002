import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/services/firebase/post_firestore.dart';
import 'package:kins_v002/view/screens/family_members_screen.dart';
import 'package:kins_v002/view/screens/followers_page.dart';
import 'package:kins_v002/view/screens/tree_screen.dart';
import 'package:kins_v002/view/tree_widgets/tree_widget.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/new_post_widget.dart';
import 'package:kins_v002/view/widgets/post_widget.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/follow_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  // final UserModel user;
  final UserModel currentUser = Get.find<UserViewModel>().currentUser!;
  final FollowViewModel _followViewModel = FollowViewModel();

  @override
  Widget build(BuildContext context) {
    // print(
    //     'Get.find<UserViewModel>().allFamily.length   ${Get.find<UserViewModel>().allFamily.length}');

    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: 40,
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Search', suffixIcon: Icon(Icons.search)
                  // border: UnderlineInputBorder(borderRadius: BorderRadius.circular(5))
                  ),
            ),
          ),
        ),
        body: FutureBuilder<Query>(
            future: PostFireStore().getUserPostsQuery(userId: currentUser.id!),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error... ${snapshot.error.toString()}'),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return PaginateFirestore(
                itemBuilder: (int index, BuildContext context,
                    DocumentSnapshot documentSnapshot) {
                  if (index == 0) {
                    return Column(
                      children: [
                        _header(context),
                        PostWidget(
                          postId: documentSnapshot.id,
                        )
                      ],
                    );
                  }

                  return PostWidget(
                    postId: documentSnapshot.id,
                  );
                },
                query: snapshot.data!,
                itemBuilderType: PaginateBuilderType.listView,
                itemsPerPage: 1,
                padding: const EdgeInsets.only(bottom: 150),
                emptyDisplay: _header(context),
                shrinkWrap: true,
              );
            }));
  }

  _header(context) {
    return Column(
      children: [
        Row(
          children: [

            /// profile image
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  ProfileCircleAvatar(
                      imageUrl: currentUser.profile,
                      radius: 50,
                      gender: currentUser.gender),
                  Positioned(
                    left: 60,
                    top: 60,
                    child: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: const Icon(Icons.camera),
                            onTap: () async {
                              final XFile? photo = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);
                              print(photo!.path.toString());
                            },
                          ),
                          PopupMenuItem(
                            child: const Icon(Icons.image),
                            onTap: () async {
                              final XFile? photo = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (photo != null) {
                                // FireStorage().uploadFile(photo.path);
                                Get.put(UserViewModel())
                                    .updateUserProfileImage(photo);
                              }
                            },
                          ),
                        ];
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width - (100 + 20 + 15),
              child: CustomText(
                text: currentUser.name ?? 'user',
                weight: FontWeight.bold,
                size: 32,
              ),
            )
          ],
        ),
        Wrap(
          children: [

            ///family tree button
            ActionChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Family Tree'.tr),
                  Icon(
                    Icons.account_tree_outlined,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
              onPressed: () {
                Get.to(TreeScreen());
              },
            ),

            ///follow button
            // user.id == currentUser.id!
            //     ? Container()
            //     : StreamBuilder<bool>(
            //         stream: _followViewModel.isFollowing(user.id!),
            //         builder: (context, snapshot) {
            //           if (snapshot.hasError || !snapshot.hasData) {
            //             return ActionChip(
            //               onPressed: () {},
            //               label: Text('      '),
            //             );
            //           }
            //           return ActionChip(
            //               label: Text(snapshot.data! ? 'Unfollow' : 'Follow'),
            //               onPressed: () {
            //                 snapshot.data!
            //                     ? _followViewModel.unFollow(userId: user.id!)
            //                     : _followViewModel.follow(userId: user.id!);
            //               });
            //         }),

            /// show followers
            ActionChip(
                label: Text('Followers'),
                onPressed: () {
                  Get.to(FollowersPage(initialIndex: 0));
                }),
            ActionChip(
                label: Text('Followings'),
                onPressed: () {
                  Get.to(FollowersPage(initialIndex: 1));
                }),

            /// family members
            ActionChip(
                label: Text('Family Members'),
                onPressed: () {
                  Get.to(FamilyMembersScreen(),
                      transition: Transition.downToUp);
                })
          ],
          spacing: 10,
          alignment: WrapAlignment.center,
        ),
        NewPostWidget(),
      ],
    );
  }

  _showTree(context, UserModel user) {
    Get.dialog(
      Scaffold(
        appBar: CustomAppBarWidget.appBar(
            title: user.name! + ' Tree'.tr, context: context),
        body: TreeWidget(
          treeOwner: user.id!,
        ),
      ),
    );
  }
}
