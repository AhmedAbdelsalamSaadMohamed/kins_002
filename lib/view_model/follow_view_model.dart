import 'package:get/get.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/services/firebase/follow_fireStore.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class FollowViewModel {
  UserModel currentUser = Get.find<UserViewModel>().currentUser!;
  UserViewModel _userFireStore = UserViewModel();
  FollowFireStore _followFireStore = FollowFireStore();

  Future<void> follow({required String userId}) async {
    _followFireStore.follow(userId: userId).then((_) {
      //getFollowingsNum();
    });
  }

  Future<void> unFollow({required String userId}) async {
    _followFireStore.unFollow(userId: userId).then((_) {});
  }

  Stream<List<Future<UserModel?>>> getUserFollowers() {
    return _followFireStore.getUserFollowers(currentUser.id!).map((event) => [
          ...event.map((id) {
            return _userFireStore.getUserFromFireStore(id);
          })
        ]);
  }

  Stream<List<Future<UserModel?>>> getUserFollowings() {
    return _followFireStore.getUserFollowings(currentUser.id!).map((event) => [
          ...event.map((id) {
            return _userFireStore.getUserFromFireStore(id);
          })
        ]);
  }

  Stream<int> getFollowersNum(String userId) {
    return _followFireStore.getFollowersNum(userId);
  }

  Stream<int> getFollowingsNum(String userId) {
    return _followFireStore.getFollowingsNum(userId);
  }

  Stream<bool> isFollowing(String userId) {
    return _followFireStore
        .getUserFollowings(currentUser.id!)
        .map((event) => event.contains(userId));
  }

  Stream<bool> isFollower(String userId) {
    return _followFireStore
        .getUserFollowers(currentUser.id!)
        .map((event) => event.contains(userId));
  }

  Stream<Stream<List<UserModel>>> getAllSuggestedUsers() {
    return _followFireStore
        .getUserFollowings(currentUser.id!)
        .map((followings) {
      bool inFollowings(String ownerId) {
        for (var element in followings) {
          if (element == ownerId) {
            return true;
          }
        }
        return false;
      }

      return _followFireStore.getAllUsersExpectMe().map((event) {
        event.removeWhere((element) => inFollowings(element.id!));
        return event;
      });
      // then((allUsers) {
      //   allUsers.removeWhere((element) => inFollowings(element.id!));
      //   return allUsers;
      // });
    });
  }
}
