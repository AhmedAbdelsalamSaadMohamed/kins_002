import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kins_v002/controllers/local_tree_controller.dart';
import 'package:kins_v002/view/tree_widgets/positioned_user_point_widget.dart';
import 'package:kins_v002/view_model/user_view_model.dart';
import 'package:zoom_widget/zoom_widget.dart';

import 'line_widget.dart';

class LocalTreeTab extends StatefulWidget {
  LocalTreeTab({Key? key}) : super(key: key);

  @override
  State<LocalTreeTab> createState() => _LocalTreeTabState();
}

class _LocalTreeTabState extends State<LocalTreeTab> {
  // BuildLocalTreeViewModel ll =
  //     Get.put(BuildLocalTreeViewModel(), permanent: true);

  @override
  Widget build(BuildContext context) {
    double mapWidth = 2000;
    double mapHeight = 2000;

    return GetBuilder<LocalTreeController>(
        init: Get.find<LocalTreeController>(),
        builder: (localTreeController) {
          print(
              '********${localTreeController.getUserById('spouserDJSop6gtwRg61qv5OYisy2jmE23')}************************************${localTreeController.userPoints[1].userId}****');
          return localTreeController.loading.value
              ? Container()
              : Zoom(
                  maxZoomHeight: 2000,
                  maxZoomWidth: 2000,
                  opacityScrollBars: 0.05,
                  backgroundColor: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: mapWidth,
                        height: mapHeight,
                        color: Colors.deepOrangeAccent,
                        child: Stack(
                          children: [
                            Container(
                              width: mapWidth + 5000,
                              height: mapHeight,
                              color: Colors.white,
                            ),
                            Positioned(
                                top: 100,
                                left: 1000,
                                child: ElevatedButton(
                                  onPressed: () {
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback((_) =>
                                            Scrollable.ensureVisible(GlobalKey(
                                                    debugLabel: Get.find<
                                                            UserViewModel>()
                                                        .currentUser!
                                                        .id)
                                                .currentContext!));
                                  },
                                  child: const Text('go'),
                                )),
                            ...[
                              ...localTreeController.userPoints
                                  .map((e) => PositionedUserPointWidget(
                                        id: e.userId,
                                        x: 0.0 + e.x,
                                        y: 0.0 + e.y,
                                        treeType: 'local',
                                      ))
                            ],
                            ...[
                              ...localTreeController.userLines
                                  .map((e) => LineWidget(line: e))
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        });
  }
}
