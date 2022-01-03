import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/model/comment_model.dart';
import 'package:kins_v002/model/notification_model.dart';
import 'package:kins_v002/services/firebase/comment_sirestore.dart';
import 'package:kins_v002/view_model/notification_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class CommentViewModel extends GetxController {
  Future publishComment(
      {required String postId, text, imageUrl, videoUrl}) async {
    print(text);
    CommentModel newComment = CommentModel(
        owner: Get.find<UserViewModel>().currentUser!.id,
        time: Timestamp.now(),
        postId: postId,
        text: text ?? ' ',
        image: imageUrl,
        video: videoUrl);
    await CommentFirestore(postId: postId).addComment(newComment).then(
        (value) => NotificationViewModel().addNotification(
            action: NotificationModel.comment,
            postId: newComment.postId!,
            time: newComment.time!,
            commentId: value));
  }

  Future<List<CommentModel>?> getPostComments(String postId) async {
    return await CommentFirestore(postId: postId).getComments();
  }

  Future<CommentModel> getComment(
      {required String postId, required String commentId}) async {
    return await CommentFirestore(postId: postId).getComment(commentId);
  }

  Future<int> getCommentsCount(String postId) async {
    return await getPostComments(postId)
        .then((value) => value == null ? 0 : value.length);
  }

  loveOrNotComment(
      {required String postId, required String commentId, required bool love}) {
    if (love) {
      CommentFirestore(postId: postId).loveComment(commentId).then((_) =>
          NotificationViewModel().addNotification(
              action: NotificationModel.lovePost,
              postId: postId,
              time: Timestamp.now()));
    } else {
      CommentFirestore(postId: postId).notLoveComment(commentId);
    }
  }
}
