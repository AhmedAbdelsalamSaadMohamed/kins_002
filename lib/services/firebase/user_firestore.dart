import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class UserFirestore {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');

  setUser(UserModel user) async {
    await _collectionReference
        .doc(user.id)
        .set(user.toJson())
        .then((value) => null);
  }

  Future<UserModel?> getUser(String userId) async {
    return await _collectionReference.doc(userId).get().then((doc) {
      if (doc.exists) {
        UserModel? user =
            UserModel.fromFire(doc.data() as Map<String, dynamic>, doc.id);
        return user;
      } else {
        return null;
      }
    });
  }

  Future<UserModel?> getUserFromFirestoreByEmail(String email) async {
    return await _collectionReference
        .where(fieldEmail, isEqualTo: email)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        UserModel? user = UserModel.fromFire(
            querySnapshot.docs.first.data() as Map<String, dynamic>,
            querySnapshot.docs.first.id);
        return user;
      } else {
        return null;
      }
    });
  }

  Future<UserModel?> getUserFromFirestoreByUsername(String token) async {
    return await _collectionReference
        .where(fieldToken, isEqualTo: token)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size > 0) {
        UserModel? user = UserModel.fromFire(
            querySnapshot.docs.first.data() as Map<String, dynamic>,
            querySnapshot.docs.first.id);
        return user;
      } else {
        return null;
      }
    });
  }

  Future<List<UserModel>> getAllRealUsers() {
    return _collectionReference
        .where(fieldEmail, isNull: false)
        //.where(fieldEmail, isNotEqualTo: '')
        // .where(fieldId, isNotEqualTo: Get.find<UserViewModel>().currentUser!.id)
        .get()
        .then((value) {
      return [
        ...value.docs.map(
            (e) => UserModel.fromFire(e.data() as Map<String, dynamic>, e.id))
      ];
    });
  }

  Future<List<UserModel>?> getSons(String dadId) async {
    List<UserModel>? sons = [];
    return await FirebaseFirestore.instance
        .collection('users')
        .where('dad', isEqualTo: dadId)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        return null;
      } else {
        value.docs.forEach((element) {
          sons.add(UserModel.fromFire(element.data(), element.id));
        });
        return sons;
      }
    });
  }

  Future<void> updateUserProfileImage(String id, String profile) async {
    UserModel user = UserModel.fromFire(
        await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .get()
            .then((value) => value.data()) as Map<String, dynamic>,
        id);
    user.profile = profile;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update(user.toJson());
  }

  Future<Stream<List<UserModel>>> searchOfUserBy(String keyword) async {
    keyword = keyword == '' ? ' ' : keyword;
    List<String> keyWords = [
      keyword,
      keyword.toUpperCase(),
      keyword.toLowerCase(),
      keyword.trim(),
      keyword[0],
      ...keyword.split('')
    ];
    Stream<QuerySnapshot> query1 = _collectionReference
        .where(fieldToken,
            isGreaterThanOrEqualTo: keyword, isLessThan: keyword + 'z')
        .snapshots();
    Stream<QuerySnapshot> query2 = _collectionReference
        .where(fieldName,
            isGreaterThanOrEqualTo: keyword, isLessThan: keyword + 'z')
        .snapshots();
    Stream<QuerySnapshot> byName =
        _collectionReference.where(fieldName, whereIn: keyWords).snapshots();
    List<UserModel> list = [];
    return StreamGroup.merge([query1, query2, byName])
        .map((QuerySnapshot query) {
      for (var element in query.docs) {
        UserModel user =
            UserModel.fromJson(element.data() as Map<String, dynamic>);
        if (!list.contains(user)) {
          list.add(user);
        }
      }
      return list;
    });
  }

  deleteUserFromFirestore(String userId) async {
    await _collectionReference.doc(userId).delete();
  }

  Future<List<UserModel>> getRequests() {
    return _collectionReference
        .where(fieldLink, isEqualTo: Get.find<UserViewModel>().currentUser!.id)
        .get()
        .then((value) => [
              ...value.docs.map((e) =>
                  UserModel.fromFire(e.data() as Map<String, dynamic>, e.id))
            ]);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRequestsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .where(fieldLink, isEqualTo: Get.find<UserViewModel>().currentUser!.id)
        .snapshots();
  }
}
