import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kins_v002/constant/constants.dart';

class CommentModel {
  String? id;
  String? postId;
  String? owner;
  String? text;
  String? image;
  String? video;
  Timestamp? time;
  List<dynamic>? loves;

  CommentModel(
      {this.id,
      this.postId,
      this.text,
      this.video,
      this.image,
      this.owner,
      this.time,
      this.loves});

  CommentModel.formFire({required Map<String, dynamic> map, required this.id})
      : text = map[fieldCommentText],
        owner = map[fieldCommentOwner],
        postId = map[fieldCommentPostId],
        image = map[fieldCommentImage],
        video = map[fieldCommentVideo],
        time = map[fieldCommentTime],
        loves = map[fieldCommentLoves];

  Map<String, dynamic> toFire() {
    return {
      fieldCommentText: text,
      fieldCommentOwner: owner,
      fieldCommentPostId: postId,
      fieldCommentImage: image,
      fieldCommentVideo: video,
      fieldCommentTime: time,
      fieldCommentLoves: loves
    };
  }

  CommentModel.formJson({required Map<String, dynamic> json})
      : id = json[fieldCommentId],
        text = json[fieldCommentText],
        owner = json[fieldCommentOwner],
        postId = json[fieldCommentPostId],
        image = json[fieldCommentImage],
        video = json[fieldCommentVideo],
        time = json[fieldCommentTime],
        loves = json[fieldCommentLoves];

  Map<String, dynamic> toJson() {
    return {
      fieldCommentId: id,
      fieldCommentText: text,
      fieldCommentOwner: owner,
      fieldCommentPostId: postId,
      fieldCommentImage: image,
      fieldCommentVideo: video,
      fieldCommentTime: time,
      fieldCommentLoves: loves
    };
  }
}
