import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kins_v002/model/comment_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/social/replies_screen.dart';
import 'package:kins_v002/view/widgets/custom_image_network.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view/widgets/video_widget.dart';
import 'package:kins_v002/view_model/comment_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

import 'custom_text.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget({Key? key, required this.comment}) : super(key: key);
  Rx<File> image = File('null').obs, video = File('null').obs;
  RxBool wait = false.obs;
  final CommentModel comment;
  RxInt lovesCount = 0.obs;
  RxBool isLove = false.obs;

  @override
  Widget build(BuildContext context) {
    lovesCount.value = comment.loves == null ? 0 : comment.loves!.length;
    isLove.value = comment.loves == null
        ? false
        : comment.loves!.contains(Get.find<UserViewModel>().currentUser!.id);
    UserModel? commentOwner;
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        elevation: 0,
        child: FutureBuilder(
            future:
                Get.find<UserViewModel>().getUserFromFireStore(comment.owner!),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                commentOwner = snapshot.data as UserModel?;
              }
              return Column(
                children: [
                  ListTile(
                    leading: ProfileCircleAvatar(
                        imageUrl:
                            commentOwner != null ? commentOwner!.profile! : '',
                        radius: 20,
                        gender: commentOwner != null
                            ? commentOwner!.gender
                            : 'male'),
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // color: Colors.grey.shade300,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: (snapshot.hasData)
                                    ? (snapshot.data as UserModel).name!
                                    : 'User',
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                              CustomText(
                                text: DateFormat('MMM-dd – kk:mm').format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        comment.time!.microsecondsSinceEpoch)),
                                size: 11,
                              ),
                              const SizedBox(height: 8),
                              CustomText(
                                text: comment.text ?? '  ',
                                size: 14,
                              ),
                              comment.image == null
                                  ? Container()
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: CustomImageNetwork(
                                          src: comment.image!)),
                              comment.video == null
                                  ? Container()
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: VideoWidget(
                                        url: video.value.path,
                                      ))
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => CustomText(text: '$lovesCount'),
                                  ),
                                  Obx(() => IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        if (isLove.value) {
                                          isLove.value = false;
                                          //lovesCount--;
                                        } else {
                                          isLove.value = true;
                                          lovesCount++;
                                        }
                                        CommentViewModel().loveOrNotComment(
                                            postId: comment.postId!,
                                            commentId: comment.id!,
                                            love: isLove.value);
                                      },
                                      icon: isLove.value
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : const Icon(Icons.favorite_border))),
                                  const SizedBox(width: 30),
                                  GestureDetector(
                                      onTap: () {
                                        Get.to(RepliesScreen(comment: comment));
                                      },
                                      child: CustomText(
                                        text: 'Replay'.tr,
                                      )),
                                ]),
                          ),
                        ]),
                  ),
                ],
              );
            }));
  }

// void _reply(context) {
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String? replyText;
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         insetPadding: const EdgeInsets.symmetric(horizontal: 1),
//         backgroundColor: Colors.transparent,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//                 padding: EdgeInsets.all(8),
//                 child: ProfileCircleAvatar(
//                     imageUrl: '', radius: 20, gender: 'male')),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(2.0),
//                 child: Form(
//                   key: _formKey,
//                   child: TextFormField(
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Can\'t Publish Empty Comment';
//                       }
//                     },
//                     onSaved: (newValue) {
//                       replyText == newValue;
//                     },
//                     decoration: InputDecoration(
//                         border: InputBorder.none,
//                         prefixIcon: _addReplyImage(),
//                         suffixIcon: IconButton(
//                             onPressed: () {
//                               _formKey.currentState!.save();
//
//                               if (_formKey.currentState!.validate()) {
//                                 // CommentViewModel()
//                                 //     .publishComment(
//                                 //     postId: post.postId!, text: replyText)
//                                 //     .then((value) =>
//                                 //     Get.off(CommentsScreen(post: post)));
//
//                               }
//                             },
//                             icon: const Icon(Icons.send)),
//                         hintText: ' Write a comment...'),
//                   ),
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: primaryColor),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// Widget _addReplyImage() {
//   return PopupMenuButton(
//       itemBuilder: (context) => [
//             PopupMenuItem(
//                 child: const Icon(
//                   Icons.image,
//                   size: 30,
//                   color: Colors.grey,
//                 ),
//                 onTap: () {
//                   Future<XFile?> xFile =
//                       ImagePicker().pickImage(source: ImageSource.gallery);
//                   xFile.then((value) {
//                     if (value != null) {
//                       image.value = File(value.path);
//                       video.value = File('null');
//                     }
//                   });
//                 }),
//             PopupMenuItem(
//                 child: const Icon(
//                   Icons.camera_alt,
//                   size: 30,
//                   color: Colors.grey,
//                 ),
//                 onTap: () {
//                   Future<XFile?> xFile =
//                       ImagePicker().pickImage(source: ImageSource.camera);
//                   xFile.then((value) {
//                     if (value != null) {
//                       image.value = File(value.path);
//                       video.value = File('null');
//                     }
//                   });
//                 }),
//             PopupMenuItem(
//                 child: const Icon(
//                   Icons.video_camera_back,
//                   size: 30,
//                   color: Colors.grey,
//                 ),
//                 onTap: () {
//                   Future<XFile?> xFile =
//                       ImagePicker().pickVideo(source: ImageSource.camera);
//                   xFile.then((value) {
//                     if (value != null) {
//                       video.value = File(value.path);
//                       image.value = File('null');
//                     }
//                   });
//                 }),
//             PopupMenuItem(
//                 child: const Icon(
//                   Icons.video_collection,
//                   size: 30,
//                   color: Colors.grey,
//                 ),
//                 onTap: () {
//                   Future<XFile?> xFile =
//                       ImagePicker().pickVideo(source: ImageSource.gallery);
//                   xFile.then((value) {
//                     if (value != null) {
//                       video.value = File(value.path);
//                       image.value = File('null');
//                     }
//                   });
//                 })
//           ],
//       icon: Obx(
//         () => video.value.path != 'null'
//             ? const Icon(
//                 Icons.video_collection,
//                 size: 30,
//                 color: primaryColor,
//               )
//             : image.value.path != 'null'
//                 ? const Icon(
//                     Icons.image,
//                     size: 30,
//                     color: primaryColor,
//                   )
//                 : const Icon(
//                     Icons.camera_alt_outlined,
//                     color: Colors.grey,
//                     size: 30,
//                   ),
//       ));
// }
}
