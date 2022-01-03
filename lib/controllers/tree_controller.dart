// import 'package:get/get.dart';
// import 'package:kins_v002/model/user_model.dart';
// import 'package:kins_v002/services/firebase/user_firestore.dart';
// import 'package:kins_v002/view_model/user_view_model.dart';
//
// class TreeController extends GetxController {
//   TreeController( {String? treeOwner}) {
//     getHeadOfDadTree(treeOwner??currentUser!.id!);
//   }
//   RxBool wait = false.obs;
//
//   UserModel? currentUser = Get.find<UserViewModel>().currentUser;
//   late String headOfDadTree;
//   List<String> dadBranch = [];
//   List<UserModel> users = [];
//
//   getHeadOfDadTree(String id) async {
//     wait.value = true;
//     dadBranch.add(id);
//     String? dadId = await UserFirestore().getUser(id).then((value) {
//       if (value == null) {
//         return null;
//       }
//       return value.dad;
//     });
//     if (dadId == null) {
//       headOfDadTree = id;
//       getUsers(headOfDadTree);
//     } else {
//       await getHeadOfDadTree(dadId);
//     }
//   }
//
//   getUsers(String dadId) async {
//     UserModel user = (await UserFirestore().getUser(dadId))!;
//     users.add(user);
//     if (user.spouse != null) {
//       UserModel spouse = (await UserFirestore().getUser(user.spouse!))!;
//
//       users.add(spouse);
//     }
//     List<UserModel>? sons = await UserFirestore().getSons(dadId);
//     if (sons != null) {
//       if (sons.isNotEmpty) {
//         for (var element in sons) {
//           //UserModel son = element;
//           getUsers(element.id!);
//           wait.value = false;
//         }
//       }
//     }
//   }
// }
