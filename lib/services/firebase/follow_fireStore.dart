import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class FollowFireStore {
  String currentUserId = Get.find<UserViewModel>().currentUser!.id!;

  Future follow({required String userId}) async {
    /// followers
    await FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionFollowers)
        .doc(currentUserId)
        .set({fieldId: currentUserId});

    ///followings
    await FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(currentUserId)
        .collection(collectionFollowings)
        .doc(userId)
        .set({fieldId: userId});
  }

  Future unFollow({required String userId}) async {
    /// followers
    await FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionFollowers)
        .doc(currentUserId)
        .delete();

    ///followings
    await FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(currentUserId)
        .collection(collectionFollowings)
        .doc(userId)
        .delete();
  }

  Stream<List<String>> getUserFollowers(String userId) {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionFollowers)
        .snapshots()
        .map((event) => [...event.docs.map((e) => e.id)]);
  }

  Stream<List<String>> getUserFollowings(String userId) {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionFollowings)
        .snapshots()
        .map((event) => [...event.docs.map((e) => e.id)]);
  }

  Stream<int> getFollowersNum(String userId) {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionFollowers)
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<int> getFollowingsNum(String userId) {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionFollowings)
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<List<UserModel>> getAllUsersExpectMe() {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .where(fieldId, isNotEqualTo: currentUserId)
        .snapshots()
        .map((event) {
      return [...event.docs.map((e) => UserModel.fromFire(e.data(), e.id))];
    });
    //     .get()
    //     .then((value) {
    //   return [
    //     ...value.docs
    //         .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
    //   ];
    // });
  }
}
