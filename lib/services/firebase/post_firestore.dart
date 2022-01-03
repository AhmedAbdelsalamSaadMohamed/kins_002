import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/notification_model.dart';
import 'package:kins_v002/model/post_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class PostFireStore {
  final CollectionReference _postsReference =
      FirebaseFirestore.instance.collection(tablePosts);
  UserModel currentUser = Get.find<UserViewModel>().currentUser!;

  Future<String> addPost(PostModel newPost) async {
    return await _postsReference.add(newPost.toFire()).then((post) {
      Get.find<UserViewModel>().allFamily.forEach((element) {
        FirebaseFirestore.instance
            .collection(tableUsers)
            .doc(element.id)
            .collection(recommendedPosts)
            .doc(post.id)
            .set({
          fieldPostId: post.id,
          fieldPostTime: newPost.postTime,
        });
      });
      return post.id;
    });
  }

  lovePost(String postId) {
    _postsReference.doc(postId).update({
      fieldPostLovesIds: FieldValue.arrayUnion([currentUser.id])
    }).then((value) {
      getPostLovers(postId).then((value) {
        value.forEach((userId) {
          NotificationModel notifi = NotificationModel(
            userId: userId,
            postId: postId,
            action: 'react',
            relation: 'reacted',
            time: Timestamp.now(),
          );
          FirebaseFirestore.instance
              .collection(tableUsers)
              .doc(userId)
              .collection(collectionNotifications)
              .add(notifi.toFire());
        });
      });
    });
  }

  notLovePost(String postId) {
    _postsReference.doc(postId).update({
      fieldPostLovesIds: FieldValue.arrayRemove([currentUser.id])
    });
  }

  // Future<List<PostModel>?> getPosts() async {
  //   List<String> allFamily = <String>[
  //     ...Get.find<UserViewModel>().allFamily.map((e) => e.id!)
  //   ];
  //   return await _postsReference
  //       .where(fieldPostOwnerId, whereIn: allFamily)
  //       .get()
  //       .then((querySnapshot) {
  //     if (querySnapshot.docs.isNotEmpty) {
  //       return [
  //         ...querySnapshot.docs.map((e) {
  //           return PostModel.fromFire(e.data() as Map<String, dynamic>, e.id);
  //         })
  //       ];
  //     }
  //   });
  // }

  Query getRecommendedPosts() {
    String userId = Get.find<UserViewModel>().currentUser!.id!;
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(recommendedPosts)
        .orderBy(fieldPostTime, descending: true);
    // if (await query1.get().then((value) => value.docs.length) == 0) {
    //   Get.find<UserViewModel>().allFamily.forEach((user) {
    //     FirebaseFirestore.instance
    //         .collection(tableUsers)
    //         .doc(user.id)
    //         .collection(recommendedPosts)
    //         .get()
    //         .then((value) => value.docs.forEach((element) {
    //               FirebaseFirestore.instance
    //                   .collection(tableUsers)
    //                   .doc(userId)
    //                   .collection(recommendedPosts)
    //                   .doc(element.id)
    //                   .set(element.data());
    //             }));
    //   });
    // }
  }

  Future<Query<Object?>> getUserPostsQuery({String? userId}) async {
    userId ?? currentUser.id!;
    return _postsReference
        .where(fieldPostOwnerId, isEqualTo: userId)
        .orderBy(fieldPostTime, descending: true);
  }

  Query getPublicPostsQuery({String? userId}) {
    userId ?? currentUser.id!;
    return _postsReference.orderBy(fieldPostTime, descending: true);
  }

  Stream<DocumentSnapshot> getPostSteam(String postId) {
    return _postsReference.doc(postId).snapshots();
  }

  Future<PostModel> getPost(String postId) async {
    return await _postsReference.doc(postId).get().then((value) =>
        PostModel.fromFire(value.data() as Map<String, dynamic>, postId));
  }

  Future<List<dynamic>> getPostLovers(String postId) async {
    return await _postsReference.doc(postId).get().then((value) {
      return (value.data() as Map<String, dynamic>)[fieldPostLovesIds]
          as List<dynamic>;
    });
  }
}
