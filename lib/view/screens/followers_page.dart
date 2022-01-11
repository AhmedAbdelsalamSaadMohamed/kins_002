import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/screens/profile_screen.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/family_view_model.dart';
import 'package:kins_v002/view_model/follow_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class FollowersPage extends StatelessWidget {
  FollowersPage({Key? key, required this.initialIndex}) : super(key: key);
  final FollowViewModel _followViewModel = FollowViewModel();
  final FamilyViewModel _familyViewModel = FamilyViewModel();
  final UserModel currentUser = Get.find<UserViewModel>().currentUser!;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentUser.name ?? ''),
          bottom: TabBar(
            tabs: [
              StreamBuilder<int>(
                  stream: _followViewModel.getFollowingsNum(currentUser.id!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Tab(
                        text: '0 ' + 'Followings'.tr,
                      );
                    }
                    return Tab(
                      text: '${snapshot.data} ' + 'Followings'.tr,
                    );
                  }),
              StreamBuilder<int>(
                  stream: _followViewModel.getFollowersNum(currentUser.id!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Tab(
                        text: '${snapshot.data} ' + 'Followers'.tr,
                      );
                    }
                    return Tab(
                      text: '${snapshot.data} ' + 'Followers'.tr,
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
            Tab(
              child: StreamBuilder<List<Future<UserModel?>>>(
                stream: _followViewModel.getUserFollowings(),
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
                        return FollowingWidget(
                            futureUser: snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
            Tab(
              child: StreamBuilder<List<Future<UserModel?>>>(
                stream: _followViewModel.getUserFollowers(),
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
                        return FollowerWidget(
                            futureUser: snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
            suggestedTab(),
          ],
        ),
      ),
    );
  }

  Widget suggestedTab() {
    return Tab(
      child: StreamBuilder<Stream<List<UserModel>>>(
          stream: _followViewModel.getAllSuggestedUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Container();
            }
            // List<UserModel> suggestedUsers = snapshot.data!;
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
                      return SuggestedWidget(user: suggestedUsers[index]);
                    },
                  );
                });
          }),
    );
  }
}

class FollowerWidget extends StatelessWidget {
  FollowerWidget({Key? key, required this.futureUser}) : super(key: key);
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
              trailing: PopupMenuButton(
                child: const Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        child: ListTile(
                      leading: const Icon(Icons.remove_circle_outline),
                      title: Text('Remove this Follower'.tr),
                      onTap: () {
                        Get.back();
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      leading: const Icon(Icons.add_circle_outline),
                      title: Text('Follow back'.tr),
                      onTap: () {
                        _followViewModel.follow(userId: user.id!);
                        Get.back();
                      },
                    )),
                  ];
                },
              ),
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

class FollowingWidget extends StatelessWidget {
  FollowingWidget({Key? key, required this.futureUser}) : super(key: key);
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
              dense: true,
              leading: ProfileCircleAvatar(
                imageUrl: user.profile,
                radius: 30,
                gender: user.gender,
              ),
              title: Text(user.name ?? ''),
              subtitle: Text(user.token ?? ''),
              trailing: PopupMenuButton(
                child: const Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        child: ListTile(
                      leading: const Icon(Icons.remove_circle_outline),
                      title: Text('UnFollow'.tr),
                      onTap: () {
                        _followViewModel.unFollow(userId: user.id!);
                        Get.back();
                      },
                    )),
                  ];
                },
              ),
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
  final FollowViewModel _followViewModel = FollowViewModel();

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
          _followViewModel.follow(userId: user.id!);
        },
        child: Text('Follow'.tr),
      ),
    );
  }
}
