import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/model/notification_model.dart';
import 'package:kins_v002/services/firebase/notification_firestore.dart';
import 'package:kins_v002/view_model/comment_view_model.dart';
import 'package:kins_v002/view_model/post_view_model.dart';
import 'package:kins_v002/view_model/reply_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class NotificationViewModel extends GetxController {
  // final String action, userId, postId;
  // String? commentId, replyId;
  // final Timestamp time;
  final NotificationFireStore _notificationFireStore = NotificationFireStore();
  final UserViewModel _userController = Get.find<UserViewModel>();
  final PostViewModel _postController = Get.put(PostViewModel());
  final CommentViewModel _commentController = Get.put(CommentViewModel());
  final ReplyViewModel _replyController = Get.put(ReplyViewModel());

  addNotification(
      {required String action,
      required String postId,
      required Timestamp time,
      String? commentId,
      String? replyId}) {
    final String userId = _userController.currentUser!.id!;
    Future<String> postOwner =
        _postController.getPost(postId).then((post) => post.ownerId!);
    Future<String>? commentOwner = (commentId == null)
        ? null
        : _commentController
            .getComment(postId: postId, commentId: commentId)
            .then((comment) => comment.owner!);

    if (action == NotificationModel.loveComment) {
      /// notifi Post owner
      postOwner.then((ownerId) {
        _notificationFireStore.addNotification(NotificationModel(
          ownerId: ownerId,
          relation: NotificationModel.create,
          userId: userId,
          action: NotificationModel.loveComment,
          postId: postId,
          commentId: commentId,
          time: time,
        ));
      });

      /// notifi comment owner
      commentOwner!.then((ownerId) {
        _notificationFireStore.addNotification(NotificationModel(
          ownerId: ownerId,
          userId: userId,
          relation: NotificationModel.comment,
          action: NotificationModel.loveComment,
          commentId: commentId,
          postId: postId,
          time: time,
        ));
      });
    }
    if (action == NotificationModel.reply) {
      /// notifi post owner
      postOwner.then((ownerId) => _notificationFireStore.addNotification(
          NotificationModel(
              ownerId: ownerId,
              relation: NotificationModel.create,
              userId: userId,
              action: NotificationModel.reply,
              postId: postId,
              commentId: commentId,
              time: time)));

      /// notifi comment Owner
      commentOwner!.then(
          (ownerId) => _notificationFireStore.addNotification(NotificationModel(
                ownerId: ownerId,
                relation: NotificationModel.comment,
                userId: userId,
                action: NotificationModel.reply,
                postId: postId,
                commentId: commentId,
                time: time,
              )));

      /// notif other replies
      _replyController
          .getCommentReplies(postId, commentId!)
          .then((replies) => replies!.forEach((reply) {
                if (reply.id != replyId) {
                  _notificationFireStore.addNotification(NotificationModel(
                    ownerId: reply.owner,
                    relation: NotificationModel.reply,
                    userId: userId,
                    action: NotificationModel.reply,
                    postId: postId,
                    commentId: commentId,
                    replyId: replyId!,
                    time: time,
                  ));
                }
              }));
    }
    if (action == NotificationModel.lovePost) {
      /// notifi post owner
      postOwner.then(
          (ownerId) => _notificationFireStore.addNotification(NotificationModel(
                ownerId: ownerId,
                relation: NotificationModel.create,
                userId: userId,
                action: NotificationModel.lovePost,
                postId: postId,
                time: time,
              )));

      /// notif post commenter s
      _commentController
          .getPostComments(postId)
          .then((comments) => comments?.forEach((comment) {
                _notificationFireStore.addNotification(NotificationModel(
                  ownerId: comment.owner,
                  relation: NotificationModel.comment,
                  userId: userId,
                  action: NotificationModel.lovePost,
                  postId: postId,
                  time: time,
                ));
              }));

      /// notifi post lovers
      _postController
          .getPost(postId)
          .then((post) => post.loves?.forEach((loverId) {
                if (loverId != userId) {
                  _notificationFireStore.addNotification(NotificationModel(
                    ownerId: loverId,
                    relation: NotificationModel.lovePost,
                    userId: userId,
                    action: NotificationModel.lovePost,
                    postId: postId,
                    time: time,
                  ));
                }
              }));
    }
    if (action == NotificationModel.comment) {
      /// notifi post owner
      postOwner.then(
          (ownerId) => _notificationFireStore.addNotification(NotificationModel(
                ownerId: ownerId,
                relation: NotificationModel.create,
                userId: userId,
                action: NotificationModel.comment,
                postId: postId,
                commentId: commentId,
                time: time,
              )));

      /// notifi post commenter s
      _commentController
          .getPostComments(postId)
          .then((comments) => comments?.forEach((comment) {
                if (comment.owner != userId) {
                  _notificationFireStore.addNotification(NotificationModel(
                    ownerId: comment.owner,
                    relation: NotificationModel.comment,
                    userId: userId,
                    action: NotificationModel.comment,
                    postId: postId,
                    commentId: commentId!,
                    time: Timestamp.now(),
                  ));
                }
              }));

      /// notifi post Lovers
      _postController
          .getPost(postId)
          .then((post) => post.loves?.forEach((loverId) {
                if (loverId != userId) {
                  _notificationFireStore.addNotification(NotificationModel(
                    ownerId: loverId,
                    relation: NotificationModel.lovePost,
                    userId: userId,
                    action: NotificationModel.comment,
                    postId: postId,
                    commentId: commentId,
                    time: time,
                  ));
                }
              }));
    }
    // if (action == NotificationModel.create) {
    //   _userController.allFamily.forEach((familyMember) {
    //     if (familyMember.id != userId) {
    //       _notificationFireStore.addNotification(NotificationModel(
    //         ownerId: familyMember.id,
    //         relation: 'familyMember',
    //         userId: userId,
    //         action: NotificationModel.create,
    //         postId: postId,
    //         time: time,
    //       ));
    //     }
    //   });
    // }
  }

  Future<int> getNotificationsCount() {
    return _notificationFireStore
        .getNotificationsCount(_userController.currentUser!.id!);
  }

  deleteNotification(NotificationModel notification) {
    _notificationFireStore.deleteNotification(notification);
  }

// sendNotification(String userId, NotificationModel notification) {
//   FirebaseFirestore.instance
//       .collection(tableUsers)
//       .doc(userId)
//       .collection(collectionNotifications)
//       .add(notification.toFire());
// }
}
