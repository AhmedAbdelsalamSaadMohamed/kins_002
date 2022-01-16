import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/post_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/services/firebase/family_firestore.dart';
import 'package:kins_v002/services/firebase/follow_fireStore.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class PostFireStore {
  final CollectionReference _postsReference =
      FirebaseFirestore.instance.collection(tablePosts);
  UserModel currentUser = Get.find<UserViewModel>().currentUser!;

  Future<String> addPost(PostModel newPost) async {
    return await _postsReference.add(newPost.toFire()).then((post) {
      return post.id;
    });
  }

  lovePost(String postId) {
    _postsReference
        .doc(postId)
        .collection(tablePostLoves)
        .doc(currentUser.id)
        .set({fieldId: currentUser.id});
  }

  notLovePost(String postId) {
    _postsReference
        .doc(postId)
        .collection(tablePostLoves)
        .doc(currentUser.id)
        .delete();
  }

  Stream<List<String>> getPostLoversIds({required String postId}) {
    return _postsReference
        .doc(postId)
        .collection(tablePostLoves)
        .snapshots()
        .map((event) => [...event.docs.map((e) => e.id)]);
  }

  Stream<int> getPostLoversCount({required String postId}) {
    return _postsReference
        .doc(postId)
        .collection(tablePostLoves)
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<bool> isLoverPost({required String postId}) {
    return _postsReference
        .doc(postId)
        .collection(tablePostLoves)
        .snapshots()
        .map((event) =>
            [...event.docs.map((e) => e.id)].contains(currentUser.id));
  }

  Query getRecommendedPosts() {
    String userId = Get.find<UserViewModel>().currentUser!.id!;
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(recommendedPosts)
        .orderBy(fieldPostTime, descending: true);
  }

  Future<Query<Object?>> getUserPostsQuery({required String userId}) async {
    return _postsReference
        .where(fieldPostOwnerId, isEqualTo: userId)
        .orderBy(fieldPostTime, descending: true);
  }

  Future<List<String>> getPublicPosts() {
    return _postsReference
        .orderBy(fieldPostTime, descending: true)
        .where(fieldPostPrivacy, isEqualTo: 'public')
        .get()
        .then((value) => [...value.docs.map((e) => e.id)]);
  }

  Future<List<String>> getFollowingPosts() {
    return FollowFireStore()
        .getUserFollowings(currentUser.id!)
        .first
        .then((followings) {
      return _postsReference
          .where(fieldPostPrivacy, isEqualTo: 'followers')
          .orderBy(fieldPostTime, descending: true)
          .get()
          .then((value) {
        List<String> result = [...value.docs.map((e) => e.id)];
        result.removeWhere((element) => !followings.contains(element));
        return result;
      });
    });
  }

  Future<List<String>> getFamilyPosts() {
    return FamilyFireStore()
        .getUserFamily(currentUser.id!)
        .first
        .then((family) {
      return _postsReference
          .where(fieldPostPrivacy, isEqualTo: 'family')
          .orderBy(fieldPostTime, descending: true)
          .get()
          .then((value) {
        List<String> result = [...value.docs.map((e) => e.id)];
        result.removeWhere((element) => !family.contains(element));
        return result;
      });
    });
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
