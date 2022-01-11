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
  final PostViewModel _postViewModel = PostViewModel();
  int count = 0;

  UserModel currentUser = Get.find<UserViewModel>().currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PostModel>(
      stream: PostViewModel().getPostStream(postId: postId),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return Container();
        }
        PostModel post = snapshot.data!;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              /// header
              FutureBuilder<UserModel?>(
                  future: UserViewModel().getUserFromFireStore(post.ownerId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Container();
                    }
                    UserModel postOwner = snapshot.data!;
                    return Row(
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
                              onTap: () =>
                                  Get.to(ProfileScreen(user: postOwner)),
                            ),
                            Text(
                              post.postTime == null
                                  ? '00:00'
                                  : DateFormat('MMM-dd – kk:mm').format(
                                      DateTime.fromMicrosecondsSinceEpoch(post
                                          .postTime!.microsecondsSinceEpoch)),
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    );
                  }),

              /// body text
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomText(
                      text: post.postText ?? ' ',
                    ),
                  ),
                ],
              ),

              /// video
              Builder(
                builder: (context) {
                  if (post.videoUrl != null) {
                    return VideoWidget(
                      url: post.videoUrl,
                    );
                  } else {
                    return Container();
                  }
                },
              ),

              /// images
              Container(
                  child: (post.imagesUrls == null || post.imagesUrls!.isEmpty)
                      ? null
                      : GestureDetector(
                          onTap: () {
                            showGallery(post, context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                ...post.imagesUrls!.map((e) {
                                  if (count++ == 0 && post.videoUrl == null) {
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
                      child: StreamBuilder<int>(
                          stream: _postViewModel.getLovesCount(postId: postId),
                          builder: (context, snapshot) {
                            return CustomText(
                              text: (snapshot.hasData
                                      ? snapshot.data!.toString()
                                      : '0') +
                                  ' ' +
                                  'Loves'.tr,
                              color: Colors.grey,
                            );
                          })),
                  GestureDetector(
                    onTap: () {
                      Get.to(CommentsScreen(
                        postId: post.postId!,
                      ));
                    },
                    child: StreamBuilder<int>(
                        stream:
                            PostViewModel().getCommentsCount(postId: postId),
                        builder: (context, snapshot) {
                          return CustomText(
                              text: snapshot.hasData
                                  ? snapshot.data.toString()
                                  : '0' + 'Comments'.tr,
                              color: Colors.grey);
                        }),
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
                  IconButton(
                      onPressed: () {
                        // if (post.loves?.contains(Get.find<UserViewModel>().currentUser!.id)??false) {
                        //   postController.isLove.value = false;
                        //   //lovesCount--;
                        // } else {
                        //   postController.isLove.value = true;
                        //   //postController.lovesCount++;
                        // }
                        PostViewModel().loveOrNotPost(
                          post.postId!,
                        );
                      },
                      icon: StreamBuilder<bool>(
                          stream: _postViewModel.isLoverPost(postId: postId),
                          builder: (context, snapshot) {
                            return (snapshot.hasData ? snapshot.data! : false)
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(Icons.favorite_border);
                          })),
                  IconButton(
                      onPressed: () {
                        Get.to(CommentsScreen(
                          postId: post.postId!,
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
      },
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
