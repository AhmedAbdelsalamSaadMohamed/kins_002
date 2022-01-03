import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kins_v002/model/message_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/widgets/custom_image_network.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

import 'image_galery_widget.dart';

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
          width: (message.imageUrl == null && message.text!.length < 20)
              ? 65.0 + message.text!.length * 16 * 2
              : MediaQuery.of(context).size.width * 0.7,
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
            title: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade300,
              ),
              child: Column(
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
                            showDialog(
                              context: context,
                              builder: (context) => ImageGalleryWidget(
                                images: [message.imageUrl!],
                              ),
                            );
                          },
                          child: CustomImageNetwork(src: message.imageUrl!))
                      : SizedBox()
                ],
              ),
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
          ),
        ),
      ],
    );
  }
}
