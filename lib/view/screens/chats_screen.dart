import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/screens/chat_screen.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class ChatsScreen extends StatelessWidget {
  ChatsScreen({Key? key}) : super(key: key);
  UserViewModel userController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget.appBar(title: 'Chats'.tr, context: context),
        body: Column(
          children: [
            _search(context),
            Expanded(child: _usersList()),
          ],
        )

        // ListView.builder(
        //   itemCount: 2,
        //   itemBuilder: (context, index) {
        //     if (index == 0) {
        //       return _search(context);
        //     } else if (index == 1) {
        //       return _usersList();
        //     } else {
        //       return _userWidget(UserModel());
        //     }
        //   },
        // ),
        );
  }

  Widget _search(context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return SizedBox(
      height: 90,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(1.0),
          child: Form(
            key: _formKey,
            child: TextFormField(
              // validator: (value) {
              //   if (value == null) {
              //     return 'Can\'t Publish Empty Comment';
              //   }
              // },
              onSaved: (newValue) {
                //commentText == newValue;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  // prefixIcon: IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.image, color: Colors.grey),
                  // ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          // CommentViewModel()
                          //     .publishComment(
                          //     postId: post.postId!, text: commentText)
                          //     .then((value) =>
                          //     Get.off(CommentsScreen(post: post)));
                        }
                      },
                      icon: const Icon(Icons.search)),
                  hintText: '   Search...'.tr),
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _usersList() {
    List<UserModel> users = [
      ...userController.allFamily.where((user) => (user.email != null &&
          user.email != '' &&
          user.id != userController.currentUser!.id))
    ];

    return FutureBuilder<List<UserModel>>(
        future: userController.getAllRealUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container();
          }
          return SizedBox(
              // height: 100,
              width: double.infinity,
              child:
                  // (users.length) < 1
                  //     ? Center(child: Text('No Users to chat'.tr))
                  //     :
                  ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: (users.length + snapshot.data!.length),
                itemBuilder: (context, index) {
                  if (index < users.length) {
                    return _userWidget(context, users[index]);
                  } else {
                    if (index == users.length) {
                      return Column(
                        children: [
                          Divider(),
                          Text('allUsers'),
                          Divider(),
                          _userWidget(
                              context, snapshot.data![index - users.length])
                        ],
                      );
                    }
                    return _userWidget(
                        context, snapshot.data![index - users.length]);
                  }
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
          size: 24,
        ),
        subtitle: InkWell(
          onTap: () {},
          child: CustomText(
            text: user.token ?? '@Unknown',
            size: 18,
            color: primaryColor,
          ),
        ),
        onTap: () {
          Get.to(ChatScreen(user: user));
        },
      ),
    );
  }
}
