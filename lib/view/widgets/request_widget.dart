import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kins_v002/model/request_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/tree_widgets/tree_widget.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/request_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

import 'custom_app_bar_widget.dart';

class RequestWidget extends StatelessWidget {
  RequestWidget({Key? key, required this.request}) : super(key: key);
  final RequestModel request;

  UserViewModel userController = Get.find<UserViewModel>();
  RequestViewModel requestController = RequestViewModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
        future: userController.getUserFromFireStore(request.senderId!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('leading...'),
            );
          }
          UserModel sender = snapshot.data!;

          return Dismissible(
            onDismissed: (direction) {},
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Delete'.tr,
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Delete'.tr)),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('Cancel'.tr))
                  ],
                ),
              );
            },
            key: ValueKey(request.id),
            child: ListTile(
              leading: ProfileCircleAvatar(
                imageUrl: sender.profile,
                radius: 20,
                gender: sender.gender,
              ),
              title: Text('${sender.name} ' +
                  'send you request to be a member of his family at'.tr +
                  ' ${DateFormat('MMM-dd – kk:mm').format(DateTime.fromMicrosecondsSinceEpoch(request.time!.microsecondsSinceEpoch))}'),
              subtitle: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        requestController.acceptRequest(request);
                      },
                      child: const Text('Accept')),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      requestController.deleteRequest(request);
                    },
                    child: Text('Delete'.tr),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text('Accept'.tr),
                      onTap: () {
                        requestController.acceptRequest(request);
                      },
                    ),
                    PopupMenuItem(
                      child: Text('Delete'.tr),
                      onTap: () {
                        RequestViewModel().deleteRequest(request);
                      },
                    ),
                    PopupMenuItem(
                      child: Text('ShowTree'.tr),
                      onTap: () async {
                        _showTree(
                            context,
                            (await userController
                                .getUserFromFireStore(request.relationId!))!);
                      },
                    ),
                  ];
                },
              ),
            ),
          );
        });
  }
}

_showTree(context, UserModel user) {
  Get.dialog(
    Scaffold(
      appBar: CustomAppBarWidget.appBar(
          title: user.name! + 'Tree'.tr, context: context),
      body: TreeWidget(
        treeOwner: user.id!,
        //isForeign: true,
      ),
      // floatingActionButton: PopupMenuButton(
      //   child: const Text('Response'),
      //   itemBuilder: (context) {
      //     return [
      //       PopupMenuItem(
      //         child: const Text('Accept'),
      //         onTap: () {},
      //       ),
      //       PopupMenuItem(
      //         child: const Text('Delete'),
      //         onTap: () {
      //           //RequestViewModel().deleteRequest(request);
      //         },
      //       ),
      //     ];
      //   },
      // ),
    ),
  );
}
