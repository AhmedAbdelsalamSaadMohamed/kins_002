import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kins_v002/constant/constants.dart';

class ReplyModel {
  String? id;
  String? commentId;
  String? owner;
  String? text;
  String? image;
  String? video;
  Timestamp? time;
  List<dynamic>? loves;

  ReplyModel(
      {this.id,
      this.commentId,
      this.owner,
      this.text,
      this.image,
      this.video,
      this.time,
      this.loves});

  ReplyModel.fromFire(Map<String, dynamic> map, this.id)
      : commentId = map[fieldReplyCommentId],
        owner = map[fieldReplyOwner],
        text = map[fieldReplyText],
        image = map[fieldReplyImage],
        video = map[fieldReplyVideo],
        time = map[fieldReplyTime],
        loves = map[fieldReplyLoves];

  Map<String, dynamic> toFire() {
    return {
      fieldReplyCommentId: commentId,
      fieldReplyOwner: owner,
      fieldReplyText: text,
      fieldReplyImage: image,
      fieldReplyVideo: video,
      fieldReplyTime: time,
      fieldReplyLoves: loves
    };
  }

  ReplyModel.fromJson(Map<String, dynamic> json)
      : id = json[fieldReplyId],
        commentId = json[fieldReplyCommentId],
        owner = json[fieldReplyOwner],
        text = json[fieldReplyText],
        image = json[fieldReplyImage],
        video = json[fieldReplyVideo],
        time = json[fieldReplyTime],
        loves = json[fieldReplyLoves];

  Map<String, dynamic> toJson() {
    return {
      fieldReplyId: id,
      fieldReplyCommentId: commentId,
      fieldReplyOwner: owner,
      fieldReplyText: text,
      fieldReplyImage: image,
      fieldReplyVideo: video,
      fieldReplyTime: time,
      fieldReplyLoves: loves
    };
  }
}
