import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/chat_model.dart';
import 'package:kins_v002/model/message_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class ChatFireStore {
  final CollectionReference _chatReference =
      FirebaseFirestore.instance.collection(collectionChats);
  UserModel currentUser = Get.find<UserViewModel>().currentUser!;

  Future<String> createChat(String user1, String user2) async {
    return await _chatReference
        .add(ChatModel(user1: user1, user2: user2).toFire())
        .then((value) => value.id);
  }

  Future<String> getChat(String user) {
    return _chatReference
        .where(fieldChatUser1, whereIn: [
          user,
          currentUser.id,
        ])
        .get()
        .then((value) async {
          var newValue = value.docs.where((element) =>
              (element.data() as Map<String, dynamic>)[fieldChatUser2] ==
                  user ||
              (element.data() as Map<String, dynamic>)[fieldChatUser2] ==
                  currentUser.id);
          if (newValue.isEmpty) {
            return _chatReference
                .doc(await createChat(user, currentUser.id!))
                .get()
                .then((value) => value.id);
          } else {
            return newValue.first.id;
          }
        });
  }

  Stream<QuerySnapshot> getChatMessagesStream(String chatId) {
    return _chatReference
        .doc(chatId)
        .collection(collectionMessages)
        .orderBy(fieldMessageTime, descending: true)
        .snapshots();
  }

  newMessage(MessageModel message, String chatId) async {
    _chatReference
        .doc(chatId)
        .collection(collectionMessages)
        .add(message.toFire());
  }
}
