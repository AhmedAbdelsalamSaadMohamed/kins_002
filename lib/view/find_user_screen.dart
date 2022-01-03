import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/random_id.dart';
import 'package:kins_v002/model/request_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/screens/add_user_screen.dart';
import 'package:kins_v002/view/widgets/add_bottum_widget.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/user_widget.dart';
import 'package:kins_v002/view_model/request_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class FindUserTab extends StatelessWidget {
  const FindUserTab({Key? key, required this.user, required this.add})
      : super(key: key);
  final UserModel user;
  final String add;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBarWidget.appBar(title: 'Find User'.tr, context: context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                Get.find<UserViewModel>().searchOfUser(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          GetX<UserViewModel>(
            init: Get.find<UserViewModel>(),
            builder: (userController) => Expanded(
                child: Container(
              child: ListView.builder(
                itemCount: userController.searchResult.value.length,
                itemBuilder: (context, index) {
                  UserModel _userSearch =
                      userController.searchResult.value[index];
                  if (_userSearch.email == null ||
                      _userSearch.token == null ||
                      _userSearch.name == 'Unknown') {
                    return Container();
                  }
                  return UserWidget(
                    user: _userSearch,
                    icon: const Icon(Icons.add),
                    // add: add,
                    // defaultUserId: user.id!,
                    onPressed: () {
                      String newId = RandomId().getId(25);
                      user.id = newId;
                      user.name = _userSearch.name;
                      user.gender = _userSearch.gender;
                      user.profile = _userSearch.profile;
                      user.link = _userSearch.id;
                      RequestViewModel().addRequest(RequestModel(
                          senderId: userController.currentUser!.id,
                          userId: _userSearch.id,
                          relationId: newId,
                          time: Timestamp.now()));
                      print('ggggggggggggggggg/' + user.id.toString());
                      Get.off(AddUserScreen(
                        add: add,
                        user: user,
                      ));
                    },
                  );
                },
              ),
            )),
          )
        ],
      ),
      bottomSheet: AddButtonWidget(
          title: 'Skip.. Can\'t find $add',
          onPressed: () {
            Get.off(AddUserScreen(
              add: add,
              user: user,
            ));
          }),
    );
  }
}
