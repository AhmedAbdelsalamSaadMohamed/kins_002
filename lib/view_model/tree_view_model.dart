import 'package:get/get.dart';
import 'package:kins_v002/model/line_model.dart';
import 'package:kins_v002/model/user_line_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/model/user_point_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class TreeViewModel extends GetxController {
  String treeOwner;

  //bool isForeign;

  TreeViewModel({required this.treeOwner /*, this.isForeign = false*/
      }) {
    userPoints = <UserPointModel>[].obs;
    getHeadOfDadTree(treeOwner);
  }

  RxBool wait = false.obs;
  UserViewModel userController = Get.find<UserViewModel>();

  UserModel? currentUser = Get.find<UserViewModel>().currentUser;
  late String headOfDadTree;
  List<String> dadBranch = [];

  //List<UserModel> users = [];
  //int x = 1;
  RxInt maxX = 1.obs, maxY = 1.obs;
  List<int> xs = [1];
  List<UserPointModel> userPoints = <UserPointModel>[];

  List<LineModel> userLines = <LineModel>[];

  reload() {
    dadBranch = [];
    maxX.value = 1;
    maxY.value = 1;
    xs = [1];
    userPoints = <UserPointModel>[].obs;
    userLines = <LineModel>[].obs;
    getHeadOfDadTree(treeOwner);
    update();
  }

  getHeadOfDadTree(String id) async {
    wait.value = true;
    dadBranch.add(id);
    print('///***///***///***/******$id');
    String?
        dadId = /*isForeign
        ? await userController
            .getUserFromFireStore(id)
            .then((value) => value!.dad)
        : */
        userController.allFamily.firstWhere((user) => user.id == id).dad;

    //
    // await UserFirestore().getUser(id).then((value) {
    //   if (value == null) {
    //     return null;
    //   }
    //   return value.dad;
    // });
    if (dadId == null) {
      headOfDadTree = id;
      //getUsers(headOfDadTree);
      getPositions();
      getLines();
      wait.value = false;
    } else {
      await getHeadOfDadTree(dadId);
    }
  }

  getPositions() {
    String head = headOfDadTree;
    getPosition(1, head);
    // update();
  }

  getPosition(int y, String id) async {
    int myx = 1;
    List<String>? sons = getSons(id);
    if (sons == null) {
      userPoints.add(UserPointModel(userId: id, x: xs[y - 1], y: y));
      xs[y - 1]++;
      String?
          spouseId = /* isForeign
          ? await userController
              .getUserFromFireStore(id)
              .then((value) => value!.dad)
          : */
          userController.allFamily
              .firstWhere((element) => element.id == id)
              .spouse;

      if (spouseId != null && spouseId != '') {
        userPoints.add(UserPointModel(userId: spouseId, x: xs[y - 1], y: y));
        xs[y - 1]++;
      }
      if (xs[y - 1] > maxX.value) {
        maxX.value = xs[y - 1];
      }
    } else {
      int newY = (y + 1);
      if (newY > maxY.value) {
        maxY.value = newY;
      }
      if (newY > xs.length) {
        xs.add(xs.last);
      }
      for (var sonId in sons) {
        myx++;
        String?
            sonSpouse = /*isForeign
            ? await userController
                .getUserFromFireStore(sonId)
                .then((value) => value!.spouse)
            : */
            userController.allFamily
                .firstWhere((element) => element.id == sonId)
                .spouse;
        if (sonSpouse != null && sonSpouse != '') {
          myx++;
        }
        getPosition(newY, sonId);
        //  xs[y-1]++;
      }
      print('------------$myx------------------------ ${xs[y]}--------');
      xs[y - 1] = (xs[y] - myx) + myx ~/ 2;
      userPoints.add(UserPointModel(userId: id, x: xs[y - 1], y: y));
      xs[y - 1]++;
      //xs[y - 1] = (xs[y] - myx) + myx ~/ 2 + 1;
      String
          spouseId = /*isForeign
          ? await userController
              .getUserFromFireStore(id)
              .then((value) => value!.spouse!)
          : */
          userController.allFamily
              .firstWhere((u) => u.id == id)
              .spouse
              .toString();
      userPoints.add(UserPointModel(userId: spouseId, x: xs[y - 1], y: y));

      xs[y - 1]++;
      if (myx == 2) xs[y]++;
    }
    // update();
  }

  List<String>? getSons(String dadId) {
    print(
        '#########################${userPoints.length}########################');

    List<String> sons = [];

    for (UserModel user in userController.allFamily) {
      if (user.dad == dadId || user.mom == dadId) {
        if (!sons.contains(user.id)) {
          sons.add(user.id!);
        }
      }
    }
    if (sons.isNotEmpty) {
      // if ((sons.toSet()).intersection(dadBranch.toSet()).isNotEmpty) {
      //   String intersect = (sons.toSet()).intersection(dadBranch.toSet()).first;
      //   sons.remove(intersect);
      //   sons.add(intersect);
      // }
      return (sons);
    } else {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  getLines() {
    String head = headOfDadTree;

    getLine(head);
    update();
  }

  getLine(String id) {
    String? spouseId = userController.allFamily
        .firstWhere((element) => element.id == id)
        .spouse;
    if (spouseId != null) {
      userLines.addAll((UserLineModel(
              userPoints.firstWhere((element) => element.userId == id),
              userPoints.firstWhere((element) => element.userId == spouseId))
          .lines));
      update();
      if (getSons(id) == null) {
        // userPoints.add(UserPointModel(userId: id, x: x, y: y));
        return;
      } else {
        List<String> sons = getSons(id)!;
        // int newY = (y + 1);
        for (var sonId in sons) {
          getLine(sonId);
          //
          UserLineModel _userLineModel = UserLineModel(
              userPoints.firstWhere((element) => element.userId == id),
              userPoints.firstWhere((element) => element.userId == sonId));
          userLines.addAll(_userLineModel.lines);
          update();
        }
      }
    }
    update();
  }
}
