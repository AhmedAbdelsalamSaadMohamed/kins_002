import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/model/comment_model.dart';
import 'package:kins_v002/services/firebase/comment_sirestore.dart';
import 'package:kins_v002/services/firebase/fire_storage.dart';
import 'package:kins_v002/view/social/replies_screen.dart';
import 'package:kins_v002/view/widgets/comment_widget.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/post_widget.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view/widgets/video_widget.dart';
import 'package:kins_v002/view_model/comment_view_model.dart';
import 'package:kins_v002/view_model/reply_view_model.dart';

class CommentsScreen extends StatelessWidget {
  CommentsScreen({Key? key, required this.postId}) : super(key: key);
  Rx<File> image = File('null').obs, video = File('null').obs;
  RxBool wait = false.obs;

  // late PostModel post;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? commentText;
  String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.appBar(
        title: 'Comments'.tr,
        context: context,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical -
              CustomAppBarWidget.appBarHeight,
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                children: [
                  PostWidget(
                    postId: postId,
                  ),
                  StreamBuilder<List<CommentModel>>(
                      stream:
                          CommentFirestore(postId: postId).getCommentsStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        List<CommentModel> comments = snapshot.data!;
                        return Column(
                          children: [
                            ...comments.map((e) => Column(
                                  children: [
                                    CommentWidget(comment: e),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 82,
                                        ),
                                        FutureBuilder(
                                          future: ReplyViewModel()
                                              .getRepliesCount(
                                                  e.postId!, e.id!),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError ||
                                                !snapshot.hasData) {
                                              return Container();
                                            } else if (snapshot.hasData &&
                                                snapshot.data! == 0) {
                                              return Container();
                                            }
                                            return GestureDetector(
                                                onTap: () =>
                                                    Get.to(RepliesScreen(
                                                      comment: e,
                                                    )),
                                                child: Text(
                                                  'Show ${snapshot.data!} Replies',
                                                  textAlign: TextAlign.start,
                                                ));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        );
                      }),
                  Obx(() => wait.value
                      ? const SizedBox(
                          height: 50,
                          child: Center(child: Text('Uploading Comment...')))
                      : Container()),
                ],
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(10),
                        child: ProfileCircleAvatar(
                            imageUrl: '', radius: 20, gender: 'male')),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(2.0),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Can\'t Publish Empty Comment'.tr;
                              }
                            },
                            onSaved: (newValue) {
                              commentText = newValue;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: _addCommentImage(),
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      _formKey.currentState!.save();
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.reset();
                                        if (image.value.path != 'null') {
                                          wait.value = true;
                                          File file = image.value;
                                          image.value = File('null');
                                          FireStorage()
                                              .uploadFile(file)
                                              .then((value) {
                                            _publish(context,
                                                videoUrl: null,
                                                imageUrl: value);
                                            wait.value = false;
                                          });
                                        } else if (video.value.path != 'null') {
                                          wait.value = true;
                                          File file = video.value;
                                          video.value = File('null');
                                          FireStorage()
                                              .uploadFile(file)
                                              .then((value) {
                                            _publish(context,
                                                videoUrl: value,
                                                imageUrl: null);
                                            wait.value = false;
                                          });
                                        } else {
                                          _publish(context,
                                              imageUrl: null, videoUrl: null);
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.send)),
                                hintText: 'Write a comment'.tr),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.secondary),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => image.value.path == 'null'
                  ? Container()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image.file(
                        image.value,
                        fit: BoxFit.fill,
                      ))),
              Obx(() => video.value.path == 'null'
                  ? Container()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: VideoWidget(
                        file: video.value,
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addCommentImage() {
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                  child: const Icon(
                    Icons.image,
                    size: 30,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Future<XFile?> xFile =
                        ImagePicker().pickImage(source: ImageSource.gallery);
                    xFile.then((value) {
                      if (value != null) {
                        image.value = File(value.path);
                        video.value = File('null');
                      }
                    });
                  }),
              PopupMenuItem(
                  child: const Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Future<XFile?> xFile =
                        ImagePicker().pickImage(source: ImageSource.camera);
                    xFile.then((value) {
                      if (value != null) {
                        image.value = File(value.path);
                        video.value = File('null');
                      }
                    });
                  }),
              PopupMenuItem(
                  child: const Icon(
                    Icons.video_camera_back,
                    size: 30,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Future<XFile?> xFile =
                        ImagePicker().pickVideo(source: ImageSource.camera);
                    xFile.then((value) {
                      if (value != null) {
                        video.value = File(value.path);
                        image.value = File('null');
                      }
                    });
                  }),
              PopupMenuItem(
                  child: const Icon(
                    Icons.video_collection,
                    size: 30,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Future<XFile?> xFile =
                        ImagePicker().pickVideo(source: ImageSource.gallery);
                    xFile.then((value) {
                      if (value != null) {
                        video.value = File(value.path);
                        image.value = File('null');
                      }
                    });
                  })
            ],
        icon: Obx(
          () => video.value.path != 'null'
              ? const Icon(
                  Icons.video_collection,
                  size: 30,
                  color: primaryColor,
                )
              : image.value.path != 'null'
                  ? const Icon(
                      Icons.image,
                      size: 30,
                      color: primaryColor,
                    )
                  : const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
        ));
  }

  _publish(context, {String? videoUrl, String? imageUrl}) {
    FocusScope.of(context).requestFocus(FocusNode());

    CommentViewModel().publishComment(
      postId: postId,
      text: commentText,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
    );
  }
}
