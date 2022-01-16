import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kins_v002/model/message_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/widgets/custom_image_network.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

import 'image_galery.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget({Key? key, required this.message, required this.user})
      : super(key: key);
  final MessageModel message;

  final UserModel user;
  final UserModel currentUser = Get.find<UserViewModel>().currentUser!;

  @override
  Widget build(BuildContext context) {
    bool isMe = message.sender == Get.find<UserViewModel>().currentUser!.id;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: ListTile(
            leading: isMe
                ? null
                : ProfileCircleAvatar(
                    imageUrl: user.profile, radius: 20, gender: user.gender),
            trailing: !isMe
                ? null
                : ProfileCircleAvatar(
                    imageUrl: currentUser.profile,
                    radius: 20,
                    gender: currentUser.gender),
            title: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                RawChip(
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(5),
                  label: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.text!,
                        maxLines: 10,
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                        style: TextStyle(fontSize: 16),
                      ),
                      message.imageUrl != null
                          ? GestureDetector(
                              onTap: () {
                                showImagesGallery(
                                    images: [message.imageUrl!], initial: 0);
                              },
                              child: SizedBox(
                                  height: 200,
                                  width: Get.width * 0.45,
                                  child: CustomImageNetwork(
                                      src: message.imageUrl!)))
                          : SizedBox()
                    ],
                  ),
                ),
              ],
            ),
            subtitle: Text(
              DateFormat('MMM-dd – kk:mm').format(
                  DateTime.fromMicrosecondsSinceEpoch(
                      message.time!.microsecondsSinceEpoch)),
              textAlign: isMe ? TextAlign.end : TextAlign.start,
              style: TextStyle(fontSize: 10),
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
