import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/view/tree_widgets/positioned_user_point_widget.dart';
import 'package:kins_v002/view/widgets/zoomable_widget.dart';
import 'package:kins_v002/view_model/tree_view_model.dart';

import 'line_widget.dart';

class TreeWidget extends StatelessWidget {
  TreeWidget({Key? key, required this.treeOwner, this.isForeign = false})
      : super(key: key) {
    controller = Get.put(TreeViewModel(treeOwner: treeOwner),
        tag: treeOwner, permanent: true);
    // treeController.reload();
  }

  String treeOwner;
  bool isForeign;
  late TreeViewModel controller;

  @override
  Widget build(BuildContext context) {
    double mapWidth = 200000;
    double mapHeight = 200000;
    // treeController.reload();

    return GetBuilder<TreeViewModel>(
        init: controller,
        builder: (treeController) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ZoomableWidget(
                child: Container(
                    color: Theme.of(context).colorScheme.background,
                    width: mapWidth,
                    height: mapHeight,
                    child: treeController.wait.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Stack(
                            children: [
                              Container(
                                width: mapWidth,
                                height: mapHeight,
                                color: Theme.of(context).colorScheme.background,
                              ),
                              Positioned(
                                top: 100,
                                left: 100,
                                child: Text(treeController.userPoints.length
                                    .toString()),
                              ),
                              ...[
                                ...treeController.userPoints
                                    .map((e) => PositionedUserPointWidget(
                                          id: e.userId,
                                          x: 0.0 + e.x,
                                          y: 0.0 + e.y,
                                          treeType: 'auth',
                                          isTreeOwner: e.userId == treeOwner,
                                        ))
                              ],
                              ...[
                                ...treeController.userLines
                                    .map((e) => LineWidget(line: e))
                              ],
                            ],
                          )),
              ),
            ),
          );
        });
  }
}
