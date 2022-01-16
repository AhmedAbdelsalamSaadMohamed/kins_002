import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/view/tree_widgets/auth_tree_tab.dart';
import 'package:kins_v002/view/tree_widgets/local_tree_tab.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';

class TreeScreen extends StatelessWidget {
  const TreeScreen({Key? key}) : super(key: key);

  //final String userId;

  @override
  Widget build(BuildContext context) {
    RxBool isLocal = false.obs;
    return Scaffold(
        appBar: CustomAppBarWidget.appBar(
            title: isLocal.value ? 'My Local Family Tree' : 'My Family Tree'.tr,
            context: context,
            actionWidget: IconButton(
                onPressed: () {
                  isLocal.value = !isLocal.value;
                },
                icon: const Icon(
                  Icons.account_tree,
                  color: Colors.grey,
                ))),
        body: RefreshIndicator(
            onRefresh: () {
              // Get.find<TreeViewModel>(
              //         tag: Get.find<UserViewModel>().currentUser!.id!)
              //     .reload();
              //isLocal.value = true;
              return Future.delayed(Duration(seconds: 1));
            },
            child: isLocal.value ? LocalTreeTab() : AuthTreeTab()));
  }
}
