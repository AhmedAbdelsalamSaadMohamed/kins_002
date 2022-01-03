import 'package:get/get.dart';
import 'package:kins_v002/model/message_model.dart';
import 'package:kins_v002/services/firebase/chat_firestore.dart';

class ChatViewModel extends GetxController {
  ChatFireStore chatFireStore = ChatFireStore();

  Future<String> getChatId(String userId) {
    return chatFireStore.getChat(userId);
  }

  sendMessage(MessageModel message, String chatId) {
    chatFireStore.newMessage(message, chatId);
  }
}
