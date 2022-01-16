import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/model/message_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/services/firebase/chat_firestore.dart';
import 'package:kins_v002/services/firebase/fire_storage.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/message_widget.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view/widgets/video_widget.dart';
import 'package:kins_v002/view_model/chat_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key, required this.user}) : super(key: key);

  final UserModel user;
  final UserModel currentUser = Get.find<UserViewModel>().currentUser!;

  Rx<File> image = File('null').obs, video = File('null').obs;
  RxBool wait = false.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? messageText;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: ChatViewModel().getChatId(user.id!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          String chatId = snapshot.data!;
          ChatViewModel().seeChat(chatId: chatId);
          return Scaffold(
            appBar:
                CustomAppBarWidget.appBar(title: user.name!, context: context),
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    CustomAppBarWidget.appBarHeight -
                    MediaQuery.of(context).padding.vertical,
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: ChatFireStore().getChatMessagesStream(chatId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('error'),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return MessageWidget(
                                  message: MessageModel.fromFire(
                                      (snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>),
                                      snapshot.data!.docs[index].id),
                                  user: user);
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: ProfileCircleAvatar(
                                  imageUrl: currentUser.profile,
                                  radius: 20,
                                  gender: currentUser.gender)),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(2.0),
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Can\'t Publish Empty Comment';
                                    }
                                  },
                                  onSaved: (newValue) {
                                    messageText = newValue;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: _addMessageImage(),
                                      suffixIcon: IconButton(
                                          onPressed: () async {
                                            _formKey.currentState!.save();
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.reset();
                                              if (image.value.path != 'null') {
                                                wait.value = true;
                                                File file = image.value;
                                                image.value = File('null');
                                                FireStorage()
                                                    .uploadFile(file)
                                                    .then((value) {
                                                  _publish(context,
                                                      chatId: chatId,
                                                      videoUrl: null,
                                                      imageUrl: value);
                                                  wait.value = false;
                                                });
                                              } else if (video.value.path !=
                                                  'null') {
                                                wait.value = true;
                                                File file = video.value;
                                                video.value = File('null');
                                                FireStorage()
                                                    .uploadFile(file)
                                                    .then((value) {
                                                  _publish(context,
                                                      chatId: chatId,
                                                      videoUrl: value,
                                                      imageUrl: null);
                                                  wait.value = false;
                                                });
                                              } else {
                                                _publish(context,
                                                    chatId: chatId,
                                                    imageUrl: null,
                                                    videoUrl: null);
                                              }
                                            }
                                          },
                                          icon: const Icon(Icons.send)),
                                      hintText: ' Write a Message...'),
                                ),
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
        });
  }

  Widget _addMessageImage() {
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

  void _publish(context, {String? chatId, String? videoUrl, String? imageUrl}) {
    // if (wait.value == false) {
    //print(chatId);
    ChatViewModel().sendMessage(
        MessageModel(
          sender: Get.find<UserViewModel>().currentUser!.id,
          receiver: user.id,
          text: messageText,
          time: Timestamp.now(),
          imageUrl: imageUrl,
          videoUrl: videoUrl,
          //imageUrls: imageUrl,
        ),
        chatId!);
    _formKey.currentState!.reset();
    //  }
    //   wait.listen((w) {
    //     if (w == false) {
    //       // CommentViewModel()
    //       //     .publishComment(
    //       //   postId: postId,
    //       //   text: messageText,
    //       //   imageUrl: imageUrl,
    //       //   videoUrl: videoUrl,
    //       // )
    //       // .then((value) => Get.off(
    //       // CommentsScreen(
    //       //   postId: postId,
    //       // ),
    //       // preventDuplicates: false))
    //
    //     }
    //   });
  }
}
