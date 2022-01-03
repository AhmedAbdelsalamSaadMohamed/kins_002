import 'package:flutter/material.dart';
import 'package:kins_v002/constant/const_colors.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';

class UserWidget extends StatelessWidget {
  const UserWidget(
      {Key? key,
      required this.user,
      required this.onPressed,
      required this.icon})
      : super(key: key);
  final UserModel user;
  final Icon icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListTile(
        leading: ProfileCircleAvatar(
            imageUrl: user.profile, radius: 20, gender: user.gender),
        title: CustomText(
          text: user.name ?? 'Unknown',
          size: 24,
        ),
        subtitle: CustomText(
          text: user.token ?? '',
          size: 18,
          color: primaryColor,
        ),
        trailing: IconButton(icon: icon, onPressed: onPressed),
      ),
    );
  }
}
