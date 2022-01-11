import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/request_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/screens/profile_screen.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/family_view_model.dart';
import 'package:kins_v002/view_model/follow_view_model.dart';
import 'package:kins_v002/view_model/request_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class FamilyMembersScreen extends StatelessWidget {
  FamilyMembersScreen({Key? key}) : super(key: key);
  final FamilyViewModel _familyViewModel = FamilyViewModel();
  final UserModel currentUser = Get.find<UserViewModel>().currentUser!;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Family"),
            bottom: TabBar(
              tabs: [
                StreamBuilder<int>(
                    stream: _familyViewModel.getFamilyCount(
                        userId: currentUser.id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasError || !snapshot.hasData) {
                        return Tab(
                          text: '${snapshot.data} ' + 'Kins',
                        );
                      }
                      return Tab(
                        text: '${snapshot.data} ' + 'Kins'.tr,
                      );
                    }),
                Tab(
                  text: 'Suggested'.tr,
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              familyTab(),
              suggestedTab(),
            ],
          )),
    );
  }

  Widget familyTab() {
    return Tab(
      child: StreamBuilder<List<Future<UserModel?>>>(
        stream: FamilyViewModel().getUserFamily(userId: currentUser.id!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return Text('Loading...'.tr);
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return KinWidget(futureUser: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget suggestedTab() {
    return Tab(
      child: StreamBuilder<Stream<Stream<Stream<List<UserModel>>>>>(
          stream: _familyViewModel.getAllSuggestedKins(),
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Container();
            }
            // List<UserModel> suggestedUsers = snapshot.data!;
            return StreamBuilder<Stream<Stream<List<UserModel>>>>(
                stream: snapshot.data!,
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Container();
                  }
                  return StreamBuilder<Stream<List<UserModel>>>(
                      stream: snapshot.data!,
                      builder: (context, snapshot) {
                        if (snapshot.hasError || !snapshot.hasData) {
                          return Container();
                        }
                        return StreamBuilder<List<UserModel>>(
                            stream: snapshot.data!,
                            builder: (context, snapshot) {
                              if (snapshot.hasError || !snapshot.hasData) {
                                return Container();
                              }
                              List<UserModel> suggestedUsers = snapshot.data!;
                              return ListView.builder(
                                itemCount: suggestedUsers.length,
                                itemBuilder: (context, index) {
                                  return SuggestedWidget(
                                      user: suggestedUsers[index]);
                                },
                              );
                            });
                      });
                });
          }),
    );
  }
}

class KinWidget extends StatelessWidget {
  KinWidget({Key? key, required this.futureUser}) : super(key: key);
  final Future<UserModel?> futureUser;
  final FollowViewModel _followViewModel = FollowViewModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (!snapshot.hasData) {
            return const ListTile(
              leading: ProfileCircleAvatar(
                imageUrl: '',
                radius: 30,
                gender: 'male',
              ),
            );
          } else {
            UserModel user = snapshot.data!;
            return ListTile(
              leading: ProfileCircleAvatar(
                imageUrl: user.profile,
                radius: 30,
                gender: 'male',
              ),
              title: Text(user.name ?? ''),
              subtitle: Text(user.token ?? ''),
              onTap: () {
                Get.to(ProfileScreen(
                  user: user,
                ));
              },
            );
          }
        });
  }
}

class SuggestedWidget extends StatelessWidget {
  SuggestedWidget({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfileCircleAvatar(
        imageUrl: user.profile,
        radius: 20,
        gender: user.gender,
      ),
      title: Text(user.name ?? ' '),
      subtitle: Text(user.token ?? ' '),
      trailing: OutlinedButton(
        onPressed: () {
          Get.to(RelationsPage(user: user), transition: Transition.leftToRight);
        },
        child: Text('Send Request'),
      ),
    );
  }
}

class RelationsPage extends StatelessWidget {
  const RelationsPage({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select the relation'),
      ),
      body: ListView(
        children: [
          ...(user.gender == "male"
              ? [
                  _relation(relation: Relations.myDad),
                  _relation(relation: Relations.myBrother),
                  _relation(relation: Relations.mySon),
                  _relation(relation: Relations.myMaternalUncle),
                  _relation(relation: Relations.myUncle),
                  _relation(relation: Relations.myGrandFather),
                ]
              : [
                  _relation(relation: Relations.myMom),
                  _relation(relation: Relations.mySister),
                  _relation(relation: Relations.myDaughter),
                  _relation(relation: Relations.myMaternalAunt),
                  _relation(relation: Relations.myAunt),
                  _relation(relation: Relations.myGrandMother),
                ])
        ],
      ),
    );
  }

  Widget _relation({required Relations relation}) {
    final String currentUserId = Get.find<UserViewModel>().currentUser!.id!;
    return ListTile(
      leading: ProfileCircleAvatar(
        imageUrl: user.profile,
        radius: 20,
        gender: user.gender,
      ),
      title: Text(user.name ?? ' '),
      subtitle: Text(_getText(relation)),
      trailing: Icon(Icons.keyboard_arrow_right_rounded),
      onTap: () {
        RequestViewModel().addRequest(RequestModel(
          senderId: currentUserId,
          userId: user.id!,
          relation: relation,
          time: Timestamp.now(),
        ));
        Get.back();
      },
    );
  }

  String _getText(Relations relation) {
    String text;
    switch (relation) {
      case Relations.myDad:
        text = 'My dad';
        break;
      case Relations.myMom:
        text = 'My mom';
        break;
      case Relations.mySon:
        text = 'My son';
        break;
      case Relations.myDaughter:
        text = 'My son';
        break;
      case Relations.myHusband:
        text = 'My husband';
        break;
      case Relations.myWife:
        text = 'My wife';
        break;
      case Relations.myBrother:
        text = 'My brother';
        break;
      case Relations.mySister:
        text = 'My sister';
        break;
      case Relations.myMaternalUncle:
        text = 'My maternal uncle';
        break;
      case Relations.myUncle:
        text = 'My uncle';
        break;
      case Relations.myMaternalAunt:
        text = 'My maternal aunt';
        break;
      case Relations.myAunt:
        text = 'My aunt';
        break;
      case Relations.myGrandFather:
        text = 'My grandfather';
        break;
      case Relations.myGrandMother:
        text = 'My grandmother';
        break;
    }
    return text;
  }
}
