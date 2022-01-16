import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/services/firebase/fire_storage.dart';
import 'package:kins_v002/services/firebase/user_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel extends GetxController {
  final UserFirestore _userFirestore = UserFirestore();

  reloadMe() {
    // loading.value = true;
    getUserFromSharedPreferences().then((value) {
      if (currentUser != null) {
        getAllFamily();
      }
    });
  }

  bool loading = false;
  UserModel? currentUser;
  bool darkMode = false;
  String language = 'en';

  setLanguage(String value) {
    language = value;
    SharedPreferences.getInstance().then(
        (sharedPreferences) => sharedPreferences.setString('language', value));
    Get.updateLocale(Locale(value));
    //update();
  }

  Future<String> getLanguage() {
    return SharedPreferences.getInstance().then((sharedPreferences) {
      return language = sharedPreferences.getString('language') ?? 'en';

      // Get.updateLocale(
      //     Locale(language));
      // //update();
    });
  }

  Rx<List<UserModel>> searchResult = Rx([]);

  Future setUserToSharedPreferences(UserModel user) async {
    currentUser = user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user.toJson())).then((value) {
      reloadMe();
      update();
    });
  }

  setDarkMode(bool value) {
    darkMode = value;
    SharedPreferences.getInstance().then(
        (sharedPreferences) => sharedPreferences.setBool('darkMode', value));
    update();
  }

  getDarkMode() {
    SharedPreferences.getInstance().then((sharedPreferences) {
      darkMode = sharedPreferences.getBool('darkMode') ?? false;
      //update();
    });
  }

  Future<void> getUserFromSharedPreferences() async {
    // loading.value = true;
    await SharedPreferences.getInstance().then((prefs) {
      String? userCode = prefs.getString('user');
      if (userCode != null) {
        currentUser = UserModel.fromJson(json.decode(userCode));
        // loading.value = false;
      } else {
        currentUser = null;
        // loading.value = false;
      }
    });
  }

  deleteUserFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  Future<bool> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  Future<UserModel?> getUserFromFireStore(String id) async {
    return _userFirestore.getUser(id);
  }

  searchOfUser(String search) async {
    searchResult.bindStream(await _userFirestore.searchOfUserBy(search));
  }

  updateUserProfileImage(XFile xFile) async {
    File file = File(xFile.path);
    String? url = await FireStorage().uploadFile(file);
    _userFirestore
        .updateUserProfileImage(currentUser!.id!, url)
        .whenComplete(() => Get.find<UserViewModel>().update());
  }

  Future setUserToFirestore(UserModel newUser) async {
    if (newUser.id == null) {
      _userFirestore.setUser(newUser);
    } else {
      UserModel? user = await getUserFromFireStore(newUser.id!);
      if (user == null) {
        _userFirestore.setUser(newUser);
      } else {
        if (newUser.name != null) {
          user.name = newUser.name;
        }
        if (newUser.gender != null) {
          user.gender = newUser.gender;
        }
        if (newUser.email != null) {
          user.email = newUser.email;
        }
        if (newUser.token != null) {
          user.token = newUser.token;
        }
        if (newUser.phone != null) {
          user.phone = newUser.phone;
        }
        if (newUser.spouse != null) {
          user.spouse = newUser.spouse;
        }
        if (newUser.dad != null) {
          user.dad = newUser.dad;
        }
        if (newUser.mom != null) {
          user.mom = newUser.mom;
        }
        _userFirestore.setUser(user);
      }
    }
  }

  Future<bool> isARealUser({required String userId}) {
    return UserViewModel().getUserFromFireStore(userId).then((user) {
      return user?.email != null;
    });
  }

  Future<List<UserModel>> getAllRealUsers() {
    return _userFirestore.getAllRealUsers();
  }

  deleteUserFromFireStore(String userId) {
    _userFirestore.deleteUserFromFirestore(userId);
  }

  Future<List<UserModel>?> getUserSonsFromFireStore(String userId) async {
    return await UserFirestore().getSons(userId);
  }

  //RxList<UserModel> allFamily = <UserModel>[].obs;
  bool sonsDone = false, dadDone = false, momDone = false, spouseDone = false;

  Future<void> getAllFamily() async {
    //allFamily.value = <UserModel>[];
    sonsDone = false;
    dadDone = false;
    momDone = false;
    spouseDone = false;
    loading = false;

    /// re do to true
    update();
    print('upppppppppppppppppppdate');

    //allFamily.add((await getUserFromFireStore(currentUser!.id!))!);

    // for (int i = 0, length = allFamily.length;
    //     i < length;
    //     length = allFamily.length, i++) {
    // UserModel user = allFamily[0];

    ///un comment
    // getParents(user).then((value) {
    //   getSons(user).then((value) {});
    // });
    // getRequests().then((users) => users.forEach((user) {
    //       print('xxxxxxxxxxxxxxxxx${user.id}xxxxxxxxxxxxxxxxxxxxxxxxx');
    //       allFamily.add(user);
    //       getParents(user).then((value) {
    //         getSons(user).then((value) {});
    //       });
    //     }));
    ///to her
    // }
  }

  Future<void> getParents(UserModel user, List<UserModel> allFamily) async {
    if (user.dad != null && user.mom != null) {
      print(
          '########${user.dad}##############################${user.id}########################');
      UserModel dad = (await getUserFromFireStore(user.dad!))!;
      UserModel mom = (await getUserFromFireStore(user.mom!))!;
      if (!allFamily.map((e) => e.id).contains(dad.id)) {
        allFamily.add(dad);
        dadDone == false;
        getParents(dad, allFamily);
        getSons(dad, allFamily);
      } else {
        dadDone = true;
        loading = !(dadDone && momDone && sonsDone && spouseDone);
        update();
        print('upppppppppppppppppppdate');
      }
      if (!allFamily.map((e) => e.id).contains(mom.id)) {
        allFamily.add(mom);
        momDone == false;
        getParents(mom, allFamily);
        getSons(mom, allFamily);
      } else {
        momDone = true;
        loading = !(dadDone && momDone && sonsDone && spouseDone);
        update();
        print('upppppppppppppppppppdate');
      }
    } else {
      dadDone = true;
      momDone = true;
      loading = !(dadDone && momDone && sonsDone && spouseDone);
      update();
      print('upppppppppppppppppppdate');
    }
  }

  Future<void> getSons(UserModel user, List<UserModel> allFamily) async {
    if (user.spouse != null) {
      UserModel spouse = (await getUserFromFireStore(user.spouse!))!;
      if (!allFamily.map((e) => e.id).contains(spouse.id)) {
        allFamily.add(spouse);
        spouseDone == false;
        getParents(spouse, allFamily);
        getSons(spouse, allFamily);
      } else {
        spouseDone = true;
        loading = !(dadDone && momDone && sonsDone && spouseDone);
        update();
        print('upppppppppppppppppppdate');
      }

      List<UserModel>? sons = await getUserSonsFromFireStore(user.id!);
      if (sons != null) {
        sons.forEach((son) {
          if (!allFamily.map((e) => e.id).contains(son.id)) {
            allFamily.add(son);
            sonsDone == false;
            getParents(son, allFamily);
            getSons(son, allFamily);
          }
        });
      } else {
        sonsDone = true;
        //loading.value = false;
        loading = !(dadDone && momDone && sonsDone && spouseDone);
        update();
        print('upppppppppppppppppppdate');
      }
    } else {
      spouseDone = true;
      sonsDone = true;
      loading = !(dadDone && momDone && sonsDone && spouseDone);
      update();
      print('upppppppppppppppppppdate');
    }
  }

  Future<List<UserModel>> getRequests() async {
    return await _userFirestore.getRequests();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRequestsSteam() {
    return _userFirestore.getRequestsStream();
  }

  @override
  void onInit() {
    super.onInit();
    reloadMe();
  }
}
