import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/model/user_point_model.dart';
import 'package:kins_v002/view/tree_widgets/positioned_user_point_widget.dart';
import 'package:kins_v002/view/widgets/zoomable_widget.dart';
import 'package:kins_v002/view_model/family_view_model.dart';
import 'package:kins_v002/view_model/tree_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

import 'line_widget.dart';

class TreeWidget extends StatelessWidget {
  TreeWidget({Key? key, required this.treeOwner, this.isForeign = false})
      : super(key: key) {
    // controller = Get.put(TreeViewModel(treeOwner: treeOwner),
    //     tag: treeOwner, permanent: true);

    // treeController.reload();
  }

  UserModel _currentUser = Get.find<UserViewModel>().currentUser!;

  String treeOwner;
  bool isForeign;

  // late TreeViewModel controller;

  @override
  Widget build(BuildContext context) {
    double mapWidth = 200000;
    double mapHeight = 200000;
    // treeController.reload();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ZoomableWidget(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            width: mapWidth,
            height: mapHeight,
            child: StreamBuilder<Future<List<UserModel>>>(
              stream: FamilyViewModel().getUserFamily(userId: treeOwner),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Container();
                }
                return FutureBuilder<List<UserModel>>(
                  future: snapshot.data!,
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Container();
                    }
                    List<UserModel> allFamily = snapshot.data!;
                    // allFamily.add(_currentUser);
                    List<UserPointModel> userPoints = TreeViewModel()
                        .getPositions(allFamily, _currentUser.id!);
                    return Stack(
                      children: [
                        Container(
                          width: mapWidth,
                          height: mapHeight,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        Positioned(
                          top: 100,
                          left: 100,
                          child: Text(userPoints.length.toString()),
                        ),
                              ...[
                          ...userPoints.map((e) => PositionedUserPointWidget(
                                id: e.userId,
                                x: 0.0 + e.x,
                                y: 0.0 + e.y,
                                treeType: 'auth',
                                isTreeOwner: e.userId == treeOwner,
                              ))
                        ],
                        ...[
                          ...TreeViewModel()
                              .getLines(allFamily, userPoints, _currentUser.id!)
                              .map((e) => LineWidget(line: e))
                        ],
                      ],
                    );
                  },
                );
              },
            ),

            // treeController.wait.value
            //     ? const Center(
            //         child: CircularProgressIndicator(),
            //       )
          ),
        ),
            ),
          );
  }
}
