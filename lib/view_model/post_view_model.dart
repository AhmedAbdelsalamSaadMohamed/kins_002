import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/model/notification_model.dart';
import 'package:kins_v002/model/post_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/services/firebase/comment_sirestore.dart';
import 'package:kins_v002/services/firebase/fire_storage.dart';
import 'package:kins_v002/services/firebase/post_firestore.dart';
import 'package:kins_v002/view_model/notification_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class PostViewModel extends GetxController {
  RxBool wait = false.obs;
  PostFireStore _postFireStore = PostFireStore();
  UserModel _currentUser = Get.find<UserViewModel>().currentUser!;

  Stream<PostModel> getPostStream({required String postId}) {
    return _postFireStore.getPostSteam(postId).map((event) =>
        PostModel.fromFire(event.data() as Map<String, dynamic>, event.id));
  }

  Stream<int> getCommentsCount({required String postId}) {
    return CommentFirestore(postId: postId).getCommentsStream().map((event) {
      return event.length;
    });
  }

  uploadPost(
      {String text = ' ',
      List<File>? images,
      File? video,
      required String privacy}) {
    List<String> imagesUrls = [];
    String? videoUrl;

    if (video != null) {
      wait.value = true;
      FireStorage().uploadFile(video).then((value) {
        videoUrl = value;
        if (images != null && images.isNotEmpty) {
          //wait.value = true;
          for (int i = 0; i < images.length; i++) {
            FireStorage().uploadFile(images[i]).then((value) {
              imagesUrls.add(value);
              if (i == images.length - 1) {
                wait.value = false;
              }
            });
          }
        } else {
          wait.value = false;
        }
      });
    } else if (images != null && images.isNotEmpty) {
      wait.value = true;

      for (int i = 0; i < images.length; i++) {
        FireStorage().uploadFile(images[i]).then((value) {
          imagesUrls.add(value);
          if (i == images.length - 1) {
            wait.value = false;
          }
        });
      }
    }
    if (!wait.value) {
      PostModel post = PostModel(
          ownerId: Get.find<UserViewModel>().currentUser!.id,
          postText: text,
          postPrivacy: privacy,
          imagesUrls: imagesUrls,
          videoUrl: videoUrl,
          postTime: Timestamp.now());
      PostFireStore().addPost(post).then((postId) {
        NotificationViewModel().addNotification(
            action: NotificationModel.create,
            postId: postId,
            time: post.postTime!);
        Get.back();
      });
    }
    wait.listen((val) {
      print('kkkk11111111111111111111kkkkkkkkkk $val kkk');
      if (!val) {
        PostModel post = PostModel(
            ownerId: Get.find<UserViewModel>().currentUser!.id,
            postText: text,
            imagesUrls: imagesUrls,
            videoUrl: videoUrl,
            postTime: Timestamp.now());
        PostFireStore().addPost(post);
      }
    });
  }

  loveOrNotPost({required bool isLoved, required String postId}) {
    if (isLoved) {
      _postFireStore.notLovePost(postId);
    } else {
      _postFireStore.lovePost(postId);
    }
    ;
  }

  Stream<bool> isLoverPost({required String postId}) {
    return _postFireStore.isLoverPost(postId: postId);
  }

  Stream<int> getLovesCount({required String postId}) {
    return _postFireStore.getPostLoversCount(postId: postId);
  }

  Future<PostModel> getPost(String postId) async {
    return await _postFireStore.getPost(postId).then((value) => value);
  }

  Future<List<String>> getPublicPosts() async {
    List<String> result = [];
    result.addAll(await _postFireStore.getPublicPosts());
    result.addAll(await _postFireStore.getFollowingPosts());
    result.addAll(await _postFireStore.getFamilyPosts());

    return [...result.toSet()];
  }

  Future<List<String>> getFamilyPosts() {
    return _postFireStore.getFamilyPosts();
  }
}
