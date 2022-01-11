import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/comment_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class CommentFirestore {
  final String postId;

  CommentFirestore({required this.postId})
      : commentsReference = FirebaseFirestore.instance
            .collection(tablePosts)
            .doc(postId)
            .collection(tableComments);
  final CollectionReference commentsReference;
  UserModel currentUser = Get.find<UserViewModel>().currentUser!;

  Future<String> addComment(CommentModel newComment) async {
    return await commentsReference
        .add(newComment.toJson())
        .then((value) => value.id);
  }

  Future<List<CommentModel>?> getComments() async {
    return [
      ...await commentsReference.get().then((value) => value.docs.map((e) =>
          CommentModel.formFire(
              map: e.data() as Map<String, dynamic>, id: e.id)))
    ];
  }

  Future<CommentModel> getComment(String commentId) async {
    return await commentsReference.doc(commentId).get().then((value) =>
        CommentModel.formFire(
            map: value.data() as Map<String, dynamic>, id: value.id));
  }

  Stream<List<CommentModel>> getCommentsStream() {
    return FirebaseFirestore.instance
        .collection(tablePosts)
        .doc(postId)
        .collection(tableComments)
        .orderBy(fieldCommentTime)
        .snapshots()
        .map((event) => [
              ...event.docs
                  .map((e) => CommentModel.formFire(map: e.data(), id: e.id))
            ]);
  }

  Future<List<dynamic>> getCommentLovers(String commentId) async {
    return await commentsReference.doc(commentId).get().then((value) {
      return (value.data() as Map<String, dynamic>)[fieldCommentLoves]
          as List<dynamic>;
    });
  }

  Future loveComment(String commentId) async {
    await commentsReference.doc(commentId).update({
      fieldCommentLoves: FieldValue.arrayUnion([currentUser.id])
    });
  }

  Future notLoveComment(String commentId) async {
    await commentsReference.doc(commentId).update({
      fieldCommentLoves: FieldValue.arrayRemove([currentUser.id])
    });
  }
}
