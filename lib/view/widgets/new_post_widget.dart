import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/view/social/create_post_sceen.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

import 'custom_text.dart';

class NewPostWidget extends StatelessWidget {
  NewPostWidget({Key? key, this.showProfile = false, this.privacy = 'public'})
      : super(key: key);

  bool showProfile;
  String privacy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showProfile
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: ProfileCircleAvatar(
                    radius: 20,
                    gender: 'male',
                    imageUrl: Get.find<UserViewModel>().currentUser!.profile,
                  ))
              : Container(),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(CreatePostScreen(
                  privacy: privacy,
                ));
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: CustomText(
                  text: 'What\'s in your mind?'.tr,
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
