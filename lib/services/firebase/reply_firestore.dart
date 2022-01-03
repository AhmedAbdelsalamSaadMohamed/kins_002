import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/reply_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class ReplyFirestore {
  ReplyFirestore({required String postId, required String commentId})
      : _repliesReference = FirebaseFirestore.instance
            .collection(tablePosts)
            .doc(postId)
            .collection(tableComments)
            .doc(commentId)
            .collection(tableReplies);
  final CollectionReference _repliesReference;
  UserModel currentUser = Get.find<UserViewModel>().currentUser!;

  Future<String> addReply(ReplyModel newReply) async {
    return await _repliesReference
        .add(newReply.toJson())
        .then((value) => value.id);
  }

  Future<List<ReplyModel>?> getReplies() async {
    return [
      ...await _repliesReference.get().then((value) => value.docs.map(
          (e) => ReplyModel.fromFire(e.data() as Map<String, dynamic>, e.id)))
    ];
  }

  Future<List<dynamic>> getReplyLovers(String replyId) async {
    return await _repliesReference.doc(replyId).get().then((value) {
      return (value.data() as Map<String, dynamic>)[fieldReplyLoves]
          as List<dynamic>;
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRepliesStream() {
    return _repliesReference.snapshots()
        as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  Future loveReply(String replyId) async {
    await _repliesReference.doc(replyId).update({
      fieldReplyLoves: FieldValue.arrayUnion([currentUser.id])
    });
  }

  notLoveReply(String replyId) {
    _repliesReference.doc(replyId).update({
      fieldReplyLoves: FieldValue.arrayRemove([currentUser.id])
    });
  }
}
