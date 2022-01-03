import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/view/widgets/add_bottum_widget.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view_model/post_view_model.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({Key? key}) : super(key: key);
  ValueNotifier<List<File>> images = ValueNotifier([]);
  ValueNotifier<File?> video = ValueNotifier<File?>(null);

  String text = '';

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
                        SizedBox(
                          height: 300,
                          child: TextFormField(
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            cursorHeight: 10,
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'What\'s in your mind?'.tr),
                            onChanged: (value) {
                              text = value;
                            },
                          ),
                        ),
                        Expanded(
                          child: ValueListenableBuilder(
                              valueListenable: video,
                              builder: (context, value, child) {
                                return ValueListenableBuilder(
                                  valueListenable: images,
                                  builder: (BuildContext context,
                                      List<File> value, Widget? child) {
                                    return GridView.builder(
                                      shrinkWrap: true,
                                      reverse: true,
                                      dragStartBehavior:
                                          DragStartBehavior.start,
                                      itemCount: value.length +
                                          (video.value == null ? 0 : 1),
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 100,
                                              mainAxisExtent: 100,
                                              crossAxisSpacing: 2,
                                              mainAxisSpacing: 2,
                                              childAspectRatio: 0.7),
                                      itemBuilder: (context, index) {
                                        if (index == 0 && video.value != null) {
                                          return Image.asset(
                                            'assets/images/video_player_placeholder.gif',
                                            fit: BoxFit.scaleDown,
                                          );
                                        } else {
                                          return Image.file(value[index -
                                              (video.value == null ? 0 : 1)]);
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
                            onPressed: () => postController.uploadPost(
                                text: text,
                                images: images.value,
                                video: video.value)),
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
