import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/view/widgets/add_bottum_widget.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/image_galery.dart';
import 'package:kins_v002/view_model/post_view_model.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({Key? key, this.privacy = 'public'}) : super(key: key);
  ValueNotifier<List<File>> images = ValueNotifier([]);
  ValueNotifier<File?> video = ValueNotifier<File?>(null);

  String text = '';
  String privacy;

  @override
  Widget build(BuildContext context) {
    video.value = null;
    return GetBuilder<PostViewModel>(
        init: Get.put(PostViewModel()),
        builder: (postController) {
          return Obx(() => Stack(
                children: [
                  Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      title: CustomText(
                        text: 'Create Post'.tr,
                        size: 24,
                        weight: FontWeight.bold,
                      ),
                      // backgroundColor: Colors.white,
                      elevation: 0.5,
                    ),
                    body: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 150,
                              child: DropdownButtonFormField<String>(
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Public'),
                                    value: 'public',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Followers'),
                                    value: 'followers',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Only Family'),
                                    value: 'family',
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Only Me'),
                                    value: 'me',
                                  ),
                                ],
                                value: privacy,
                                onChanged: (value) {
                                  privacy = value!;
                                },
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(5)),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TextFormField(
                            maxLines: null,
                            keyboardType: TextInputType.text,
                            cursorHeight: 10,
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                              hintText: 'What\'s in your mind?'.tr,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            onChanged: (value) {
                              text = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: ValueListenableBuilder(
                              valueListenable: video,
                              builder: (context, value, child) {
                                return ValueListenableBuilder(
                                  valueListenable: images,
                                  builder: (BuildContext context,
                                      List<File> value, Widget? child) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      reverse: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: value.length +
                                          (video.value == null ? 0 : 1),
                                      itemBuilder: (context, index) {
                                        if (index == 0 && video.value != null) {
                                          return Image.asset(
                                            'assets/images/video_player_placeholder.gif',
                                            fit: BoxFit.scaleDown,
                                          );
                                        } else {
                                          return GestureDetector(
                                            child: Image.file(value[index -
                                                (video.value == null ? 0 : 1)]),
                                            onTap: () {
                                              showImagesGallery(images: [
                                                value[index -
                                                        (video.value == null
                                                            ? 0
                                                            : 1)]
                                                    .path
                                              ], initial: 0, fromFile: true);
                                            },
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Future<List<XFile>?> xFile =
                                        ImagePicker().pickMultiImage();
                                    xFile.then((values) {
                                      if (values != null) {
                                        images.value.addAll([
                                          ...values.map((e) => File(e.path))
                                        ]);
                                        images.notifyListeners();
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.grey,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    Future<XFile?> xFile = ImagePicker()
                                        .pickImage(source: ImageSource.camera);
                                    xFile.then((value) {
                                      if (value != null) {
                                        images.value.add(File(value.path));
                                        images.notifyListeners();
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    Future<XFile?> xFile = ImagePicker()
                                        .pickVideo(source: ImageSource.camera);
                                    xFile.then((value) {
                                      if (value != null) {
                                        video.value = File(value.path);
                                        video.notifyListeners();
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.video_camera_back,
                                    size: 50,
                                    color: Colors.grey,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    Future<XFile?> xFile = ImagePicker()
                                        .pickVideo(source: ImageSource.gallery);
                                    xFile.then((value) {
                                      if (value != null) {
                                        video.value = File(value.path);
                                        video.notifyListeners();
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.video_collection,
                                    size: 50,
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        ),
                        AddButtonWidget(
                            title: 'Post'.tr,
                            onPressed: () {
                              postController.uploadPost(
                                  text: text,
                                  privacy: privacy,
                                  images: images.value,
                                  video: video.value);
                              Get.back();
                            }),
                      ],
                    ),
                  ),
                  postController.wait.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            semanticsLabel: 'Post Uploading...'.tr,
                          ),
                        )
                      : Container()
                ],
              ));
        });
  }
}
