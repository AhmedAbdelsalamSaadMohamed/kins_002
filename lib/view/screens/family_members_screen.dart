import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/screens/relations_page.dart';
import 'package:kins_v002/view/screens/requests_from_me_page.dart';
import 'package:kins_v002/view/screens/requests_to_me_page.dart';
import 'package:kins_v002/view/screens/user_screen.dart';
import 'package:kins_v002/view/widgets/profile_circle_avatar.dart';
import 'package:kins_v002/view_model/family_view_model.dart';
import 'package:kins_v002/view_model/follow_view_model.dart';
import 'package:kins_v002/view_model/request_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class FamilyMembersScreen extends StatefulWidget {
  FamilyMembersScreen({Key? key}) : super(key: key);
  int currentTab = 0;

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  final FamilyViewModel _familyViewModel = FamilyViewModel();
  final UserModel currentUser = Get.find<UserViewModel>().currentUser!;
  PageController _pageController = PageController(keepPage: true);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    title: Text("Family"),
                  ),
                  SliverAppBar(
                    pinned: true,
                    automaticallyImplyLeading: false,
                    toolbarHeight: 100,
                    flexibleSpace: Wrap(
                      children: [
                        CustomActionChip(
                          label: StreamBuilder<int>(
                              stream: _familyViewModel.getRealFamilyCount(
                                  userId: currentUser.id!),
                              builder: (context, snapshot) {
                                if (snapshot.hasError || !snapshot.hasData) {
                                  return Text(
                                    '${snapshot.data} ' + 'Kins',
                                  );
                                }
                                return Text(
                                  '${snapshot.data} ' + 'Kins'.tr,
                                );
                              }),
                          onPressed: () {
                            setState(() {
                              widget.currentTab = 0;
                            });
                          },
                          pageController: _pageController,
                          index: 0,
                          currentTab: widget.currentTab,
                        ),
                        CustomActionChip(
                          label: Text('Suggested'.tr),
                          onPressed: () {
                            setState(() {
                              widget.currentTab = 1;
                            });
                          },
                          pageController: _pageController,
                          index: 1,
                          currentTab: widget.currentTab,
                        ),
                        StreamBuilder<int>(
                            stream: RequestViewModel().getRequestsFromMeCount(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError || !snapshot.hasData) {
                                return CustomActionChip(
                                    label: Text('  ' + 'Requests From Me'),
                                    index: 2,
                                    currentTab: widget.currentTab,
                                    pageController: _pageController,
                                    onPressed: () {
                                      setState(() {
                                        widget.currentTab = 2;
                                      });
                                    });
                              }
                              return CustomActionChip(
                                  label: Text(snapshot.data.toString() +
                                      ' ' +
                                      'Requests From Me'),
                                  index: 2,
                                  currentTab: widget.currentTab,
                                  pageController: _pageController,
                                  onPressed: () {
                                    setState(() {
                                      widget.currentTab = 2;
                                    });
                                  });
                            }),
                        StreamBuilder<int>(
                            stream: RequestViewModel().getRequestsToMeCount(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError || !snapshot.hasData) {
                                return CustomActionChip(
                                    label: Text('  ' + 'Requests To Me'),
                                    index: 3,
                                    currentTab: widget.currentTab,
                                    pageController: _pageController,
                                    onPressed: () {
                                      setState(() {
                                        widget.currentTab = 3;
                                      });
                                    });
                              }
                              return CustomActionChip(
                                  label: Text(snapshot.data!.toString() +
                                      ' ' +
                                      'Requests To Me'),
                                  index: 3,
                                  currentTab: widget.currentTab,
                                  pageController: _pageController,
                                  onPressed: () {
                                    setState(() {
                                      widget.currentTab = 3;
                                    });
                                  });
                            }),
                      ],
                      spacing: 8,
                    ),
                  )
                ];
              },
              body: PageView(
                children: [
                  familyTab(),
                  suggestedTab(),
                  RequestsFromMePage(),
                  RequestsToMePage(),
                ],
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    widget.currentTab = value;
                  });
                },
              )),
        ),
      ),
    );
  }

  Widget familyTab() {
    return Tab(
      child: StreamBuilder<List<Future<UserModel?>>>(
        stream: FamilyViewModel().getUserRealFamily(userId: currentUser.id!),
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
    return StreamBuilder<Stream<Stream<Stream<List<UserModel>>>>>(
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
        });
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
                Get.to(UserScreen(
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

class CustomActionChip extends StatelessWidget {
  const CustomActionChip(
      {Key? key,
      required this.label,
      required this.pageController,
      required this.index,
      required this.currentTab,
      required this.onPressed})
      : super(key: key);
  final Widget label;
  final int index, currentTab;
  final PageController pageController;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: label,
      onPressed: () {
        pageController.jumpToPage(
          index,
          // duration: Duration(microseconds: 1), curve: Curves.ease
        );
        onPressed();
      },
      labelStyle:
          currentTab == index ? TextStyle(color: Colors.red) : TextStyle(),
    );
  }
}
