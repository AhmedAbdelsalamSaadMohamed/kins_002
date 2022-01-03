import 'package:kins_v002/constant/constants.dart';

class ChatModel {
  String? id;
  String? user1;
  String? user2;

  ChatModel({this.id, this.user1, this.user2});

  ChatModel.fromFire(Map<String, dynamic> map, this.id)
      : user1 = map[fieldChatUser1],
        user2 = map[fieldChatUser2];

  Map<String, dynamic> toFire() =>
      {fieldChatId: id, fieldChatUser1: user1, fieldChatUser2: user2};
}
