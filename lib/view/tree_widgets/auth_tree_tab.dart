import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/view/tree_widgets/tree_widget.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class AuthTreeTab extends StatelessWidget {
  const AuthTreeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TreeWidget(
      treeOwner: Get.find<UserViewModel>().currentUser!.id!,
    );
  }
}
