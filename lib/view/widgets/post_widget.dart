import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kins_v002/model/post_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/screens/profile_screen.dart';
import 'package:kins_v002/view/social/comments_screen.dart';
import 'package:kins_v002/view/widgets/custom_image_network.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/image_galery_widget.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view/widgets/video_widget.dart';
import 'package:kins_v002/view_model/post_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class PostWidget extends StatelessWidget {
  PostWidget({Key? key, required this.postId}) : super(key: key);
  final String postId;
  int count = 0;

  UserModel currentUser = Get.find<UserViewModel>().currentUser!;

  @override
  Widget build(BuildContext context) {
    PostViewModel postController =
        Get.put(PostViewModel.byTag(postId), tag: postId);
    UserModel? postOwner = postController.post.ownerId == currentUser.id
        ? currentUser
        : postController.post.ownerId == null
            ? UserModel()
            : Get.find<UserViewModel>().allFamily.firstWhere(
                (element) => element.id == postController.post.ownerId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          /// header
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  child: ProfileCircleAvatar(
                      imageUrl: postOwner.profile,
                      radius: 20,
                      gender: postOwner.gender),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ImageGalleryWidget(
                          images: [postOwner.profile.toString()]),
                    );
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Row(
                      children: [
                        CustomText(
                          text: postOwner.name ?? ' ',
                          size: 16,
                        ),
                        CustomText(
                          text: ' ${postOwner.token ?? '@'}',
                          size: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4),
                        ),
                      ],
                    ),
                    onTap: () => Get.to(ProfileScreen(user: postOwner)),
                  ),
                  Text(
                    postController.post.postTime == null
                        ? '00:00'
                        : DateFormat('MMM-dd – kk:mm').format(
                            DateTime.fromMicrosecondsSinceEpoch(postController
                                .post.postTime!.microsecondsSinceEpoch)),
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ],
          ),

          /// body text
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomText(
                  text: postController.post.postText ?? ' ',
                ),
              ),
            ],
          ),

          /// video
          Builder(
            builder: (context) {
              if (postController.post.videoUrl != null) {
                return VideoWidget(
                  url: postController.post.videoUrl,
                );
              } else {
                return Container();
              }
            },
          ),

          /// images
          Container(
              child: (postController.post.imagesUrls == null ||
                      postController.post.imagesUrls!.isEmpty)
                  ? null
                  : GestureDetector(
                      onTap: () {
                        showGallery(postController.post, context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            ...postController.post.imagesUrls!.map((e) {
                              if (count++ == 0 &&
                                  postController.post.videoUrl == null) {
                                return CustomImageNetwork(src: e);
                              } else {
                                return Container(
                                  height: 100,
                                  width: 100,
                                  padding: const EdgeInsets.all(8),
                                  child: CustomImageNetwork(src: e),
                                );
                              }
                            })
                          ],
                        ),
                      ),
                    )),

          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () {},
                  child: Obx(() => CustomText(
                        text: postController.lovesCount.toString() + 'Loves'.tr,
                        color: Colors.grey,
                      ))),
              GestureDetector(
                onTap: () {
                  Get.to(CommentsScreen(
                    postId: postController.post.postId!,
                  ));
                },
                child: Obx(
                  () => CustomText(
                      text: postController.commentsCount.value.toString() +
                          'Comments'.tr,
                      color: Colors.grey),
                ),
              ),
              GestureDetector(
                  onTap: () {},
                  child: CustomText(text: 'Shares'.tr, color: Colors.grey)),
            ],
          ),

          /// Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(() => IconButton(
                  onPressed: () {
                    if (postController.isLove.value) {
                      postController.isLove.value = false;
                      //lovesCount--;
                    } else {
                      postController.isLove.value = true;
                      //postController.lovesCount++;
                    }
                    PostViewModel().loveOrNotPost(postController.post.postId!,
                        postController.isLove.value);
                  },
                  icon: postController.isLove.value
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border))),
              IconButton(
                  onPressed: () {
                    Get.to(CommentsScreen(
                      postId: postController.post.postId!,
                    ));
                  },
                  icon: const Icon(Icons.comment_outlined)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.share_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  void showGallery(PostModel post, context) {
    showDialog(
      context: context,
      builder: (context) {
        return ImageGalleryWidget(images: [...post.imagesUrls!]);
      },
    );
  }
}
