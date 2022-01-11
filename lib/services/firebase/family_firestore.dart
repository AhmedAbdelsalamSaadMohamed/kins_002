import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class FamilyFireStore {
  String currentUserId = Get.find<UserViewModel>().currentUser!.id!;

  Future addToFamily({required String userId}) async {
    await FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionFamily)
        .doc(currentUserId)
        .set({fieldId: currentUserId});
  }

  Future RemoveFromFamily({required String userId}) async {
    await FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionFamily)
        .doc(currentUserId)
        .delete();
  }

  Stream<List<String>> getUserFamily(String userId) {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionFamily)
        .snapshots()
        .map((event) => [...event.docs.map((e) => e.id)]);
  }

  Stream<int> getFamilyCount(String userId) {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionFamily)
        .snapshots()
        .map((event) => event.docs.length);
  }
}
