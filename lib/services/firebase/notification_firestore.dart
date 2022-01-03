import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/notification_model.dart';

class NotificationFireStore {
  addNotification(NotificationModel notification) {
    FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(notification.ownerId)
        .collection(collectionNotifications)
        .add(notification.toFire());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotificationsStream(
      String userId) {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionNotifications)
        .orderBy(fieldNotificationTime)
        .snapshots();
  }

  Future<int> getNotificationsCount(String userId) {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionNotifications)
        .orderBy(fieldNotificationTime)
        .get()
        .then((value) => value.docs.length);
  }

  deleteNotification(NotificationModel notification) {
    FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(notification.ownerId)
        .collection(collectionNotifications)
        .doc(notification.id)
        .delete();
  }
}
