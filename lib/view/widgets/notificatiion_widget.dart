import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kins_v002/model/notification_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/social/comments_screen.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/notification_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class NotificationWidget extends StatelessWidget {
  NotificationWidget({Key? key, required this.notification}) : super(key: key);
  final NotificationModel notification;
  final UserViewModel userController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    // PostViewModel postController =
    //     Get.put(PostViewModel.byTag(postId), tag: postId);
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete'.tr),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Delete'.tr)),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'.tr)),
          ],
        ),
      ),
      onDismissed: (direction) =>
          NotificationViewModel().deleteNotification(notification),
      child: FutureBuilder<UserModel?>(
          future: userController.getUserFromFireStore(notification.userId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error'.tr);
            }
            if (!snapshot.hasData) {
              return Container();
            }
            UserModel user = snapshot.data!;
            return ListTile(
              onTap: () {
                NotificationViewModel().deleteNotification(notification);
                Get.off(CommentsScreen(postId: notification.postId!));
              },
              leading: ProfileCircleAvatar(
                  imageUrl: user.profile, radius: 20, gender: user.gender),
              title: Text(
                  '${user.name}  ${_notificationText() == '' ? '${notification.action} post ' : _notificationText()}'),
              subtitle: Text(
                  'At ${DateFormat('MMM-dd – kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(notification.time!.microsecondsSinceEpoch))}'),
            );
          }),
    );
  }

  String _notificationText() {
    String text = '';
    if (notification.relation == NotificationModel.create) {
      switch (notification.action) {
        case NotificationModel.comment:
          {
            text += 'Comment on post you are created'.tr;
            break;
          }
        case NotificationModel.lovePost:
          {
            text += 'Love post you are created'.tr;
            break;
          }
        case NotificationModel.reply:
          {
            text += 'make reply on post you are created'.tr;
            break;
          }
        case NotificationModel.loveComment:
          {
            text += 'love comment on post you are created'.tr;
            break;
          }
      }
    }
    if (notification.relation == NotificationModel.comment) {
      switch (notification.action) {
        case NotificationModel.comment:
          {
            text += 'Comment on post you are commented'.tr;
            break;
          }
        case NotificationModel.lovePost:
          {
            text += 'Love post you are commented'.tr;
            break;
          }
        case NotificationModel.reply:
          {
            text += 'make reply on post you are Commented'.tr;
            break;
          }
        case NotificationModel.loveComment:
          {
            text += 'love your comment on post'.tr;
            break;
          }
      }
    }
    if (notification.relation == NotificationModel.reply) {
      switch (notification.action) {
        case NotificationModel.comment:
          {
            text += 'Comment on post you are replied a comment'.tr;
            break;
          }
        case NotificationModel.lovePost:
          {
            text += 'Love post you are replied a comment'.tr;
            break;
          }
        case NotificationModel.reply:
          {
            text += 'make reply on post you are replied'.tr;
            break;
          }
        case NotificationModel.loveComment:
          {
            text += 'love a comment on post you are replied'.tr;
            break;
          }
      }
    }
    if (notification.relation == NotificationModel.lovePost) {
      switch (notification.action) {
        case NotificationModel.comment:
          {
            text += 'Comment on post you are loved'.tr;
            break;
          }
        case NotificationModel.lovePost:
          {
            text += 'Love post you are loved'.tr;
            break;
          }
        case NotificationModel.reply:
          {
            text += 'make reply on post you are loved'.tr;
            break;
          }
        case NotificationModel.loveComment:
          {
            text += 'love a comment on post you are loved'.tr;
            break;
          }
      }
    }
    if (notification.relation == NotificationModel.loveComment) {
      switch (notification.action) {
        case NotificationModel.comment:
          {
            text += 'Comment on post you are loved a comment'.tr;
            break;
          }
        case NotificationModel.lovePost:
          {
            text += 'Love post you are loved a comment'.tr;
            break;
          }
        case NotificationModel.reply:
          {
            text += 'make reply on post you are loved a comment'.tr;
            break;
          }
        case NotificationModel.loveComment:
          {
            text += 'love a comment on post you are loved comment'.tr;
            break;
          }
      }
    }
    return text;
  }
}
