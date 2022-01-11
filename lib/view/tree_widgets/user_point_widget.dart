import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/controllers/local_tree_controller.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/find_user_screen.dart';
import 'package:kins_v002/view/screens/edit_user_screen.dart';
import 'package:kins_v002/view/tree_widgets/add_widget.dart';
import 'package:kins_v002/view/tree_widgets/tree_widget.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class UserPointWidget extends StatelessWidget {
  UserPointWidget(
      {Key? key,
      required this.id,
      required this.treeType,
      this.isTreeOwner = false});

  final String id, treeType;
  final bool isTreeOwner;
  final LocalTreeController localController = Get.find<LocalTreeController>();
  final UserViewModel controller = Get.find<UserViewModel>();
  late UserModel user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserViewModel().getUserFromFireStore(id),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return GestureDetector(
              child: Container(
                key: key,
                width: 0.0 + userPointWidth,
                height: 0.0 + userPointHeight,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: isTreeOwner ? 2 : 1,
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(5)),
              ),
            );
          }
          {
            user = snapshot.data as UserModel;
            return Column(
              children: [
                Container(
                  key: key,
                  width: 0.0 + userPointWidth,
                  height: 0.0 + userPointHeight,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: isTreeOwner ? 2 : 1,
                          color: isTreeOwner
                              ? Colors.red
                              : user.link != null
                                  ? Colors.yellow
                                  : Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(5)),
                  child: user.name == 'Unknown'
                      ? ElevatedButton(
                          onPressed: () {
                            Get.to(EditUserScreen(user: user));
                          },
                          child: Text(user.gender == 'male'
                              ? 'ADD Father'.tr
                              : 'ADD Mother'.tr))
                      : Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: 0,
                            leading: ProfileCircleAvatar(
                                imageUrl: user.profile,
                                radius: 15,
                                gender: user.gender),
                            title: CustomText(
                              text: user.name ?? 'Unknown',
                              size: 10,
                            ),
                            // subtitle:
                            trailing: PopupMenuButton(
                              padding: EdgeInsets.zero,
                              color: Theme.of(context).colorScheme.background,
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                      child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Get.off(EditUserScreen(user: user));
                                    },
                                  )),
                                  PopupMenuItem(
                                    child: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        _showAddDialog();
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                      child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      Get.find<LocalTreeController>()
                                          .deleteUser(id);
                                    },
                                  )),
                                  PopupMenuItem(
                                      child: IconButton(
                                    icon: const Icon(Icons.account_tree),
                                    onPressed: () => _showTree(context, user),
                                  )),
                                ];
                              },
                            ),
                          ),
                        ),
                ),
              ],
            );
          }
        });
  }

  _showTree(context, UserModel user) {
    Get.dialog(
      Scaffold(
        appBar: CustomAppBarWidget.appBar(
            title: user.name! + ' Tree'.tr, context: context),
        body: TreeWidget(
          treeOwner: id,
        ),
      ),
    );
  }

  _addFather() {
    ///edit user
    UserModel newUser = user;
    newUser.mom = 'mom${user.id}';
    newUser.dad = 'dad${user.id}';
    _addUser(newUser);

    /// add mom
    UserModel mom = UserModel(
        id: 'mom${user.id}',
        spouse: 'dad${user.id}',
        gender: 'female',
        name: 'Unknown');
    _addUser(mom);

    ///add dad
    _addUserNavigator(
      add: 'Father',
      user: UserModel(
        id: 'dad${user.id}',
        gender: 'male',
        spouse: 'mom${user.id}',
      ),
    );
  }

  _addMother() {
    UserModel newUser = user;
    newUser.mom = 'mom${user.id}';
    newUser.dad = 'dad${user.id}';
    _addUser(newUser);
    UserModel newDad = UserModel(
        id: 'dad${user.id}',
        spouse: 'mom${user.id}',
        gender: 'male',
        name: 'Unknown');
    _addUser(newDad);
    _addUserNavigator(
      add: 'Mother',
      user: UserModel(
        id: 'mom${user.id}',
        gender: 'female',
        spouse: 'dad${user.id}',
      ),
    );
  }

  _addBrother() {
    _addUserNavigator(
      add: 'Brother',
      user: UserModel(
        dad: user.dad,
        mom: user.mom,
        gender: 'male',
      ),
    );
  }

  _addSister() {
    _addUserNavigator(
      add: 'Sister',
      user: UserModel(
        dad: user.dad,
        mom: user.mom,
        gender: 'female',
      ),
    );
  }

  _addSon() {
    if (user.spouse == null) {
      _addUser(UserModel(
        id: 'spouse${user.id}'.toString(),
        name: 'Unknown',
        gender: user.gender == 'male' ? 'female' : 'male',
        spouse: user.id,
      ));

      UserModel newUser = user;
      newUser.spouse = 'spouse${user.id}';
      _addUser(newUser);

      _addUserNavigator(
        add: 'Son',
        user: UserModel(
          dad: user.gender == 'male' ? user.id : 'spouse${user.id}',
          mom: user.gender == 'male' ? 'spouse${user.id}' : user.id,
          gender: 'male',
        ),
      );
    } else {
      _addUserNavigator(
        add: 'Son',
        user: UserModel(
          dad: user.id,
          mom: user.spouse,
          gender: 'male',
        ),
      );
    }
  }

  _addDaughter() {
    if (user.spouse == null) {
      /// add spouse
      _addUser(UserModel(
        id: 'spouse${user.id}',
        name: 'Unknown',
        gender: user.gender == 'male' ? 'female' : 'male',
        spouse: user.id,
      ));

      /// edit relation

      UserModel newUser = user;
      newUser.spouse = 'spouse${user.id}';
      _addUser(newUser);

      /// add daughter
      _addUserNavigator(
        add: 'Daughter',
        user: UserModel(
          dad: user.id,
          mom: 'spouse${user.id}',
          gender: 'female',
        ),
      );
    } else {
      _addUserNavigator(
        add: 'Daughter',
        user: UserModel(
          dad: user.id,
          mom: user.spouse,
          gender: 'female',
        ),
      );
    }
  }

  _addSpouse() {
    _addUserNavigator(
      add: user.gender == 'male' ? 'Wife'.tr : 'Husband'.tr,
      user: UserModel(
          spouse: user.id, gender: user.gender == 'male' ? 'female' : 'male'),
    );
  }

  _showAddDialog() {
    return Get.dialog(
      //context: context,
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Close'.tr,
                      style: TextStyle(color: Colors.red, fontSize: 24),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    user.dad != null
                        ? Container()
                        : AddWidget(
                            text: 'ADD Father'.tr,
                            onTab: _addFather,
                          ),
                    user.mom != null
                        ? Container()
                        : AddWidget(
                            text: 'ADD Mother'.tr,
                            onTab: _addMother,
                          )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AddWidget(
                      text: 'ADD Brother'.tr,
                      onTab: _addBrother,
                    ),
                    AddWidget(
                      text: 'ADD Sister'.tr,
                      onTab: _addSister,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AddWidget(
                      text: 'ADD Spouse'.tr,
                      onTab: _addSpouse,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AddWidget(
                      text: 'ADD Son'.tr,
                      onTab: _addSon,
                    ),
                    AddWidget(
                      text: 'ADD Daughter'.tr,
                      onTab: _addDaughter,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addUserNavigator({required UserModel user, required String add}) {
    if (treeType == 'auth') {
      Get.off(FindUserTab(
        add: add,
        user: user,
      ));
    } else {
      //Get.off(AddLocalUserScreen(add: add, user: user));
    }
  }

  _addUser(UserModel newUser) {
    if (treeType == 'auth') {
      controller.allFamily.add(newUser);
      controller.setUserToFirestore(newUser);
    } else {
      localController.setUser(newUser);
    }
  }
}
