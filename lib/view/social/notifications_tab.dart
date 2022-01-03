import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/model/notification_model.dart';
import 'package:kins_v002/services/firebase/notification_firestore.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/notificatiion_widget.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget.appBar(
          title: 'Notifications'.tr, context: context),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: NotificationFireStore()
            .getNotificationsStream(Get.find<UserViewModel>().currentUser!.id!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (!snapshot.hasData) {
            return Text('Loading...'.tr);
          }
          if (snapshot.data!.size == 0) {
            return Center(child: Text('No Notifications'.tr));
          }
          return ListView(
            children: [
              ...snapshot.data!.docs.map((e) => NotificationWidget(
                    notification: NotificationModel.fromFire(e.data(), e.id),
                  ))
            ],
          );
        },
      ),
    );
  }
}
