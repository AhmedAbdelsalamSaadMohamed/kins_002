import 'package:get/get.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/services/firebase/family_firestore.dart';
import 'package:kins_v002/services/firebase/follow_fireStore.dart';
import 'package:kins_v002/view_model/request_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class FamilyViewModel {
  FamilyFireStore _familyFireStore = FamilyFireStore();
  String currentUserId = Get.find<UserViewModel>().currentUser!.id!;

  addToFamily({required String userId}) {
    _familyFireStore.addToFamily(userId: userId);
  }

  removeFromFamily({required String userId}) {
    _familyFireStore.RemoveFromFamily(userId: userId);
  }

  Stream<List<Future<UserModel?>>> getUserFamily({required String userId}) {
    return _familyFireStore.getUserFamily(userId).map((event) =>
        [...event.map((e) => UserViewModel().getUserFromFireStore(e))]);
  }

  Stream<int> getFamilyCount({required String userId}) {
    return _familyFireStore.getFamilyCount(userId);
  }

  Stream<Stream<Stream<Stream<List<UserModel>>>>> getAllSuggestedKins() {
    return _familyFireStore.getUserFamily(currentUserId).map((kins) {
      bool inFamily(String ownerId) {
        for (var element in kins) {
          if (element == ownerId) {
            return true;
          }
        }
        return false;
      }

      return RequestViewModel().getRequestsFromMe().map((event) {
        bool inFromMeRequests(String ownerId) {
          for (var element in <String>[...event.map((e) => e.userId!)]) {
            if (element == ownerId) {
              return true;
            }
          }
          return false;
        }

        return RequestViewModel().getRequestsToMe().map((event) {
          bool inToMyRequests(String ownerId) {
            for (var element in event.map((e) => e.senderId)) {
              if (element == ownerId) {
                return true;
              }
            }
            return false;
          }

          return FollowFireStore().getAllUsersExpectMe().map((event) {
            event.removeWhere((element) => inFamily(element.id!));
            event.removeWhere((element) => inFromMeRequests(element.id!));
            event.removeWhere((element) => inToMyRequests(element.id!));
            return event;
          });
        });
      });

      // then((allUsers) {
      //   allUsers.removeWhere((element) => inFollowings(element.id!));
      //   return allUsers;
      // });
    });
  }
}
