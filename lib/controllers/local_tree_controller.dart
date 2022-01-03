import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kins_v002/model/line_model.dart';
import 'package:kins_v002/model/user_line_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/model/user_point_model.dart';
import 'package:kins_v002/services/sqflite/user_sqflite_database.dart';
import 'package:kins_v002/view_model/user_view_model.dart';
import 'package:sqflite/sqflite.dart';

import '../constant/constants.dart';

class LocalTreeController extends GetxController {
  LocalTreeController() {
    getAllUsers();
  }

  ValueNotifier<bool> loading = ValueNotifier<bool>(false);

  List<UserModel> allUsers = [];
  List<String> dadBranch = [];
  List<String> momBranch = [];
  String? headOfTree;
  String? headOfMomTree;

  getHeadOfTree(String id) {
    dadBranch.add(id);
    String? dadId = allUsers.firstWhere(
      (element) => element.id == id,
      orElse: () {
        return UserModel();
      },
    ).dad;

    if (dadId == null) {
      headOfTree = id;
    } else {
      getHeadOfTree(dadId);
    }
  }

  getHeadOfMomTree(String id) {
    momBranch.add(id);

    String? dadId = allUsers.firstWhere((element) => element.id == id).dad;

    if (dadId == null) {
      headOfMomTree = id;
    } else {
      getHeadOfMomTree(dadId);
    }
  }

  Future getAllUsers() async {
    dadBranch = [];
    momBranch = [];
    loading = ValueNotifier<bool>(true);
    Database myDB = await UserSqfliteDatabase.db.database;
    myDB.rawQuery('''
    SELECT * FROM $tableUsers
    ''').then((value) {
      if (value.isNotEmpty) {
        allUsers = [
          ...value.map((e) {
            return UserModel.fromJson(e);
          })
        ];
        getHeadOfTree(Get.find<UserViewModel>().currentUser!.id!);
        getHeadOfMomTree(allUsers
            .firstWhere((element) =>
                element.id == Get.find<UserViewModel>().currentUser!.id!)
            .mom!);
        getLocalPositions().then((value) {
          //getLocalPositionsMomTree().then((value) => getLines());
          getLines();
        });
      } else {
        initMainUser().whenComplete(() {
          getAllUsers();
        });
      }
    });
  }

  Future initMainUser() async {
    UserModel currentUser = Get.find<UserViewModel>().currentUser!;
    // if ( users.length == 0)
    {
      setUser(UserModel(
        name: 'Unknown',
        id: 'dad${currentUser.id}',
        spouse: 'mom${currentUser.id}',
        gender: 'male',
      ));
      setUser(UserModel(
          name: 'Unknown',
          id: 'mom${currentUser.id}',
          spouse: 'dad${currentUser.id}',
          gender: 'female'));
      // if (dadId != null && momId != null) {
      UserModel user = UserModel(
          id: currentUser.id,
          profile: currentUser.profile,
          email: currentUser.email,
          name: currentUser.name,
          dad: currentUser.dad ?? 'dad${currentUser.id}',
          mom: currentUser.mom ?? 'mom${currentUser.id}',
          gender: currentUser.gender,
          phone: currentUser.phone,
          spouse: currentUser.spouse);
      setUser(user);
    }
  }

  int x = 0;
  String userId = Get.find<UserViewModel>().currentUser!.id!;
  List<UserPointModel> userPoints = [];
  List<LineModel> userLines = [];

  Future getLocalPositions() async {
    x = 0;
    int y = 1;
    if (dadBranch.length <= momBranch.length) {
      y += momBranch.length - dadBranch.length + 1;
    }
    userPoints = [];
    getLocalPosition(y, headOfTree!);

    update();
  }

  Future getLocalPositionsMomTree() async {
    x = 0;
    int y = 1;
    if (dadBranch.length > momBranch.length) {
      y += dadBranch.length - dadBranch.length - 1;
    }
    userPoints = [];
    getLocalPosition(y, headOfMomTree!);

    update();
  }

  getLocalPosition(int y, String id) {
    int saveX = x;
    int myx = 1;
    if (getSons(id) == null) {
      userPoints.add(UserPointModel(userId: id, x: x, y: y));
      String? spouse = allUsers.firstWhere((e) => e.id == id).spouse;
      if (spouse != null) {
        userPoints.add(UserPointModel(userId: spouse, x: ++x, y: y));
      }
    } else {
      List<String> sons = getSons(id)!;
      int newY = (y + 1);
      for (var sonId in sons) {
        getLocalPosition(newY, sonId);
        x++;
        myx = (myx + 1);
      }
      userPoints
          .add(UserPointModel(userId: id, x: saveX + (myx ~/ 2) - 1, y: y));
      String spouseId =
          allUsers.firstWhere((element) => element.id == id).spouse.toString();

      userPoints
          .add(UserPointModel(userId: spouseId, x: saveX + (myx ~/ 2), y: y));
    }
  }

  List<String>? getSons(String dadId) {
    List<String> sons = [];
    for (UserModel user in allUsers) {
      if (user.dad == dadId) {
        sons.add(user.id!);
      }
    }
    if (sons.isNotEmpty) {
      Set<String>? set = (sons.toSet()).intersection(dadBranch.toSet());
      if (set.isNotEmpty) {
        String intersect = set.first;
        sons.remove(intersect);
        sons.add(intersect);
      }

      /// //////////////for mom///////////////////
      //  set =(sons.toSet()).intersection(momBranch.toSet());
      // if(set.isNotEmpty){
      //   String intersect = set.first;
      //   List<String> list = [];
      //   list.add(intersect);
      //   sons.remove(intersect);
      //    list.addAll([...sons]);
      //   sons =[ ...list];
      // }

      return (sons);
    } else {
      return null;
    }
  }

  getLines() {
    userLines = [];

    getLine(headOfTree!);
    loading = ValueNotifier<bool>(false);
  }

  getLine(String id) {
    if (getSons(id) == null) {
      String? spouse =
          allUsers.firstWhere((element) => element.id == id).spouse;
      if (spouse != null) {
        userLines.addAll((UserLineModel(
                userPoints.firstWhere((element) => element.userId == id),
                userPoints.firstWhere((element) => element.userId == spouse))
            .lines));
      }
    } else {
      List<String> sons = getSons(id)!;

      // int newY = (y + 1);
      for (var sonId in sons) {
        getLine(sonId);
        UserLineModel _userLineModel = UserLineModel(
            userPoints.firstWhere((element) => element.userId == id),
            userPoints.firstWhere((element) => element.userId == sonId));
        userLines.addAll(_userLineModel.lines);
      }

      String spouseId =
          allUsers.firstWhere((element) => element.id == id).spouse.toString();
      userLines.addAll((UserLineModel(
              userPoints.firstWhere((element) => element.userId == id),
              userPoints.firstWhere((element) => element.userId == spouseId))
          .lines));
    }
  }

  Future<UserModel?> getUserById(String id) async {
    Database myDB = await UserSqfliteDatabase.db.database;
    UserModel? user;
    List<Map> result =
        await myDB.query(tableUsers, where: 'id ==?', whereArgs: [id]);
    if (result.length > 0) {
      user = UserModel.fromJson(result.first as Map<String, dynamic>);
      return user;
    }
    return user;
  }

  // Future addUser(UserModel user) async {
  //   Database myDB = await UserSqfliteDatabase.db.database;
  //   await myDB
  //       .insert(tableUsers, user.toJson())
  //       .then((value) => getAllUsers().then((value) => update()));
  // }

  Future deleteUser(String id) async {
    Database myDB = await UserSqfliteDatabase.db.database;
    await myDB.delete(tableUsers, where: '$fieldId == ? ', whereArgs: [
      id
    ]).then((value) => getAllUsers().then((value) {
          getLines();
          update();
        }));
  }

  Future setUser(UserModel newUser) async {
    Database myDB = await UserSqfliteDatabase.db.database;
    UserModel? user = await getUserById(newUser.id!);
    if (user == null) {
      await myDB
          .insert(tableUsers, newUser.toJson())
          .then((value) => getAllUsers().then((value) => update()));
    } else {
      if (newUser.spouse != null) {
        user.spouse = newUser.spouse;
      }
      if (newUser.dad != null) {
        user.dad = newUser.dad;
      }
      if (newUser.mom != null) {
        user.mom = newUser.mom;
      }
      if (newUser.name != null) {
        user.name = newUser.name;
      }
      if (newUser.gender != null) {
        user.gender = newUser.gender;
      }
      if (newUser.phone != null) {
        user.phone = newUser.phone;
      }
      if (newUser.email != null) {
        user.email = newUser.email;
      }
      if (newUser.token != null) {
        user.token = newUser.token;
      }
      myDB.update(tableUsers, user.toJson(), where: 'id ==?', whereArgs: [
        user.id
      ]).then((value) => getAllUsers().then((value) => update()));
    }
  }
}

dropTable() async {
  Database myDB = await UserSqfliteDatabase.db.database;
  await myDB
      .execute('Drop Table users')
      .then((value) => print('drooooooooooooooooooooooooooooooop'));
}
