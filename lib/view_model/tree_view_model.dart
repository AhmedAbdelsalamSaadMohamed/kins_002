import 'package:get/get.dart';
import 'package:kins_v002/model/line_model.dart';
import 'package:kins_v002/model/user_line_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/model/user_point_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class TreeViewModel extends GetxController {
  UserViewModel userController = Get.find<UserViewModel>();

  UserModel? currentUser = Get.find<UserViewModel>().currentUser;
  List<String> dadBranch = [];

  //int x = 1;
  RxInt maxX = 1.obs, maxY = 1.obs;
  List<int> xs = [1];

  String getHeadOfDadTree(String id, List<UserModel> allFamily) {
    String result = '';
    _getHead(
      String _id,
    ) {
      dadBranch.add(_id);
      String? dadId = allFamily
          .firstWhere(
            (user) => user.id == _id,
            orElse: () => UserModel(),
          )
          .dad;
      if (dadId == null) {
        result = _id;
      } else {
        _getHead(dadId);
      }
    }

    _getHead(id);
    return result;
  }

  List<UserPointModel> getPositions(
      List<UserModel> allFamily, String treeOwner) {
    String head = getHeadOfDadTree(treeOwner, allFamily);
    List<UserPointModel> userPoints = <UserPointModel>[];
    getPosition(int y, String id, List<UserModel> allFamily) {
      int myx = 1;
      List<String>? sons = getSons(id, allFamily);

      if (sons == null) {
        print(id);
        print(sons?.length.toString());
        userPoints.add(UserPointModel(userId: id, x: xs[y - 1], y: y));
        xs[y - 1]++;
        String? spouseId = allFamily
            .firstWhere(
              (element) => element.id == id,
              orElse: () => UserModel(),
            )
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
          String? sonSpouse =
              allFamily.firstWhere((element) => element.id == sonId).spouse;
          if (sonSpouse != null && sonSpouse != '') {
            myx++;
          }
          getPosition(newY, sonId, allFamily);
        }
        xs[y - 1] = (xs[y] - myx) + myx ~/ 2;
        userPoints.add(UserPointModel(userId: id, x: xs[y - 1], y: y));
        xs[y - 1]++;
        String spouseId = allFamily.firstWhere((u) => u.id == sons[0]).dad == id
            ? allFamily.firstWhere((u) => u.id == sons[0]).mom!
            : allFamily.firstWhere((u) => u.id == sons[0]).dad!;
        userPoints.add(UserPointModel(userId: spouseId, x: xs[y - 1], y: y));

        xs[y - 1]++;
        if (myx == 2) xs[y]++;
      }
    }

    getPosition(1, head, allFamily);
    return userPoints;
  }

  List<String>? getSons(String dadId, List<UserModel> allFamily) {
    List<String> sons = [];

    for (UserModel user in allFamily) {
      if (user.dad == dadId || user.mom == dadId) {
        if (!sons.contains(user.id)) {
          sons.add(user.id!);
        }
      }
    }
    if (sons.isNotEmpty) {
      return (sons);
    } else {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  List<LineModel> getLines(List<UserModel> allFamily,
      List<UserPointModel> userPoints, String treeOwner) {
    String head = getHeadOfDadTree(treeOwner, allFamily);

    return getLine(head, allFamily, userPoints);
  }

  List<LineModel> getLine(
      String id, List<UserModel> allFamily, List<UserPointModel> userPoints) {
    List<LineModel> userLines = <LineModel>[];

    List<String>? sons = getSons(id, allFamily);
    if (sons != null) {
      String? spouseId = allFamily.firstWhere((u) => u.id == sons[0]).dad == id
          ? allFamily.firstWhere((u) => u.id == sons[0]).mom!
          : allFamily.firstWhere((u) => u.id == sons[0]).dad!;
      userLines.addAll((UserLineModel(
              userPoints.firstWhere((element) => element.userId == id),
              userPoints.firstWhere((element) => element.userId == spouseId))
          .lines));
      for (var sonId in sons) {
        getLine(sonId, allFamily, userPoints);
        UserLineModel _userLineModel = UserLineModel(
            userPoints.firstWhere((element) => element.userId == id),
            userPoints.firstWhere((element) => element.userId == sonId));
        userLines.addAll(_userLineModel.lines);
      }
      //}
    } else {}
    return userLines;
  }
}
