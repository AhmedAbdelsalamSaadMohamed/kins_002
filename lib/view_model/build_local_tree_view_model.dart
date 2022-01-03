// import 'package:get/get.dart';
// import 'package:kins_v002/controllers/auth_controller.dart';
// import 'package:kins_v002/controllers/local_tree_controller.dart';
// import 'package:kins_v002/model/line_model.dart';
// import 'package:kins_v002/model/user_line_model.dart';
// import 'package:kins_v002/model/user_model.dart';
// import 'package:kins_v002/model/user_point_model.dart';
//
// class BuildLocalTreeViewModel extends GetxController {
//   BuildLocalTreeViewModel() {
//     getLocalPositions().then((value) {
//       getLines();
//     });
//   }
//
//   List<UserModel> users = [];
//   int x = 0;
//   String userId = Get.find<AuthController>().currentUser!.id!;
//  // String? _headOfTree = Get.find<LocalTreeController>().headOfTree;
//
//   List<UserPointModel> userPoints = [];
//   List<LineModel> userLines = [];
//
//   Future getLocalPositions() async {
//     x = 0;
//     await Get.find<LocalTreeController>().getAllUsers().then((_) {
//       users = Get.find<LocalTreeController>().allUsers;
//       userPoints = [];
//       String head = Get.find<LocalTreeController>().headOfTree!;
//       getLocalPosition(1, head);
//       print(
//           '++++++${users.length}+++++++getLocalPositions() {++++++++++++++++++${userPoints.length}++');
//     });
//     update();
//   }
//
//   getLocalPosition(int y, String id) {
//     int myx = 0;
//     if (getSons(id) == null) {
//       userPoints.add(UserPointModel(userId: id, x: x, y: y));
//     } else {
//       List<String> sons = getSons(id)!;
//       int newY = (y + 1);
//       for (var sonId in sons) {
//         getLocalPosition(newY, sonId);
//         x++;
//         myx = (myx + 1);
//       }
//       userPoints.add(UserPointModel(userId: id, x: (x - myx) + myx % 2, y: y));
//       String spouseId =
//           users.firstWhere((element) => element.id == id).spouse.toString();
//       userPoints.add(
//           UserPointModel(userId: spouseId, x: (x - myx) + myx % 2 + 1, y: y));
//     }
//   }
//
//   List<String>? getSons(String dadId) {
//     List<String> sons = [];
//     for (UserModel user in users) {
//       if (user.dad == dadId) {
//         sons.add(user.id!);
//       }
//     }
//     if (sons.isNotEmpty) {
//       //String intersect = (sons.toSet()).intersection(dadBranch.toSet()).first;
//       // sons.remove(intersect);
//       // sons.add(intersect);
//       return (sons);
//     } else {
//       return null;
//     }
//   }
//
// //////////////////////////////////////////////////
//   ////////////////////////////////////////////////////////////////////////////
//   getLines() {
//     userLines = [];
//     String head = Get.find<LocalTreeController>().headOfTree!;
//
//     getLine(head);
//     print('++++++++++++getLines() {++++++++++++++++++++++++++++++++');
//     update();
//   }
//
//   getLine(String id) {
//     if (getSons(id) == null) {
//       // userPoints.add(UserPointModel(userId: id, x: x, y: y));
//       return;
//     } else {
//       List<String> sons = getSons(id)!;
//       // int newY = (y + 1);
//       for (var sonId in sons) {
//         getLine(sonId);
//         //
//         UserLineModel _userLineModel = UserLineModel(
//             userPoints.firstWhere((element) => element.userId == id),
//             userPoints.firstWhere((element) => element.userId == sonId));
//         userLines.addAll(_userLineModel.lines);
//       }
//
//       String spouseId = Get.find<LocalTreeController>()
//           .allUsers
//           .firstWhere((element) => element.id == id)
//           .spouse
//           .toString();
//       userLines.addAll((UserLineModel(
//               userPoints.firstWhere((element) => element.userId == id),
//               userPoints.firstWhere((element) => element.userId == spouseId))
//           .lines));
//     }
//   }
// }
