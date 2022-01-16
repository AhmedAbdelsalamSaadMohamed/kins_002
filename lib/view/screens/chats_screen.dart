import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/model/chat_model.dart';
import 'package:kins_v002/model/message_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/screens/chat_screen.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/chat_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key}) : super(key: key);
  int currentIndex = 0;

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  UserViewModel userController = Get.find<UserViewModel>();
  UserModel _currentUser = Get.find<UserViewModel>().currentUser!;
  ChatViewModel _chatViewModel = ChatViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.appBar(title: 'Chats'.tr, context: context),
      body: Column(
        children: [
          _search(context),
          Expanded(
              child: widget.currentIndex == 0 ? _chatsList() : _usersList()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.chat_bubble_outline,
                  ),
                ),
                Positioned(
                  bottom: 3,
                  right: 3,
                  child: Icon(Icons.chat_bubble_outline),
                ),
              ],
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded), label: 'People'),
        ],
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _search(context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            onSaved: (newValue) {},
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {}
                    },
                    icon: const Icon(Icons.search)),
                hintText: '   Search...'.tr),
          ),
        ),
      ),
    );
  }

  Widget _usersList() {
    return FutureBuilder<List<UserModel>>(
        future: userController.getAllRealUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container();
          }
          snapshot.data!
              .removeWhere((element) => element.id == _currentUser.id);
          return SizedBox(
              // height: 100,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: (snapshot.data!.length),
                itemBuilder: (context, index) {
                  return _userWidget(context, snapshot.data![index]);
                },
              ));
        });
  }

  Widget _chatsList() {
    return FutureBuilder<List<ChatModel>>(
        future: ChatViewModel().getChats(),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container();
          }
          return SizedBox(
              // height: 100,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: (snapshot.data!.length),
                itemBuilder: (context, index) {
                  return _chatWidget(context, snapshot.data![index]);
                },
              ));
        });
  }

  Widget _userWidget(context, UserModel user) {
    return SizedBox(
      //height: 100,
      width: Get.width,
      child: ListTile(
        leading: ProfileCircleAvatar(
            imageUrl: user.profile, radius: 20, gender: user.gender),
        title: CustomText(
          text: user.name ?? 'Unknown',
        ),
        subtitle: InkWell(
          onTap: () {},
          child: CustomText(
            text: user.token ?? '@Unknown',
            color: primaryColor,
          ),
        ),
        onTap: () {
          Get.to(ChatScreen(user: user));
        },
      ),
    );
  }

  Widget _chatWidget(context, ChatModel chat) {
    String userId = chat.user1 == _currentUser.id ? chat.user2! : chat.user1!;
    return FutureBuilder<UserModel?>(
        future: UserViewModel().getUserFromFireStore(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container();
          }
          return ListTile(
            leading: ProfileCircleAvatar(
              radius: 20,
              gender: snapshot.data!.gender,
              imageUrl: snapshot.data!.profile,
            ),
            title: Text(snapshot.data!.name ?? ''),
            subtitle: StreamBuilder<MessageModel>(
              stream: _chatViewModel.getLastMessage(chatId: chat.id!),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Text('');
                }
                return Text(snapshot.data!.text ?? 'no text');
              },
            ),
            trailing: SizedBox(
              width: 50,
              child: StreamBuilder<int>(
                stream:
                    _chatViewModel.getNotSeenMessagesCount(chatId: chat.id!),
                builder: (context, snapshot) {
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data! < 1) {
                    return Container();
                  }
                  return Chip(
                    label: Text(
                      snapshot.data!.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.all(1.0),
                  );
                },
              ),
            ),
            onTap: () {
              Get.to(ChatScreen(user: snapshot.data!));
            },
          );
        });
  }
}
