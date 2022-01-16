import 'package:get/get.dart';
import 'package:kins_v002/model/chat_model.dart';
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

  Future<List<ChatModel>> getChats() {
    return chatFireStore.getUserChats();
  }

  Stream<int> getNotSeenMessagesCount({required String chatId}) {
    return chatFireStore.getNotSeenMessagesCount(chatId: chatId);
  }

  Stream<int> getNotSeenChatsCount() {
    return chatFireStore.getNotSeenChatsCount();
  }

  Stream<MessageModel> getLastMessage({required String chatId}) {
    return chatFireStore.getLastMessage(chatId: chatId);
  }

  seeChat({required String chatId}) {
    chatFireStore.seeChat(chatId: chatId);
  }
}
