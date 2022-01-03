import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kins_v002/constant/constants.dart';

class NotificationModel {
  static const create = 'create';
  static const comment = 'comment';
  static const reply = 'replay';
  static const lovePost = 'lovePost';
  static const loveComment = 'loveComment';
  String? id;
  String? userId;
  String? ownerId;
  String? postId;
  String? commentId;
  String? replyId;
  String? action;
  Timestamp? time;
  String? relation;

  NotificationModel(
      {this.id,
      this.ownerId,
      this.userId,
      this.postId,
      this.commentId,
      this.replyId,
      this.action,
      this.time,
      this.relation});

  NotificationModel.fromFire(Map<String, dynamic> map, this.id)
      : ownerId = map[fieldNotificationOwnerId],
        userId = map[fieldNotificationUserId],
        postId = map[fieldNotificationPostId],
        commentId = map[fieldNotificationCommentId],
        replyId = map[fieldNotificationReplyId],
        action = map[fieldNotificationAction],
        time = map[fieldNotificationTime],
        relation = map[fieldNotificationRelation];

  Map<String, dynamic> toFire() => {
        fieldNotificationOwnerId: ownerId,
        fieldNotificationUserId: userId,
        fieldNotificationPostId: postId,
        fieldNotificationCommentId: commentId,
        fieldNotificationReplyId: replyId,
        fieldNotificationAction: action,
        fieldNotificationTime: time,
        fieldNotificationRelation: relation,
      };
}
