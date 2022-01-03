import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kins_v002/constant/constants.dart';

class MessageModel {
  String? id;

  // String? chatId;
  String? sender;
  String? receiver;
  Timestamp? time;
  String? imageUrl;
  String? videoUrl;
  String? text;

  MessageModel(
      {this.id,
      // this.chatId,
      this.sender,
      this.receiver,
      this.time,
      this.imageUrl,
      this.videoUrl,
      this.text});

  MessageModel.fromFire(Map<String, dynamic> map, this.id)
      : //chatId = map[fieldMessageChatId],
        sender = map[fieldMessageSender],
        receiver = map[fieldMessageReceiver],
        time = map[fieldMessageTime],
        imageUrl = map[fieldMessageImage],
        videoUrl = map[fieldMessageVideo],
        text = map[fieldMessageText];

  Map<String, dynamic> toFire() => {
        fieldMessageId: id,
        // fieldMessageChatId : chatId,
        fieldMessageSender: sender,
        fieldMessageReceiver: receiver,
        fieldMessageTime: time,
        fieldMessageImage: imageUrl,
        fieldMessageVideo: videoUrl,
        fieldMessageText: text,
      };
}
