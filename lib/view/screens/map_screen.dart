import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:graphview/GraphView.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/view/tree_widgets/user_point_widget.dart';
import 'package:kins_v002/view/widgets/custom_app_bar_widget.dart';
import 'package:kins_v002/view/widgets/custom_text.dart';
import 'package:kins_v002/view_model/build_map_view_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  final Graph graph = Graph();
  SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..nodeSeparation = 30
    ..orientation = 1
    ..levelSeparation = 100;
  List<GlobalKey> keys = <GlobalKey>[];
  final TransformationController transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return getx.GetBuilder<BuildMapViewModel>(
        init: getx.Get.put(BuildMapViewModel(), permanent: true),
        builder: (mapController) {
          if (mapController.usersNodes.length == 1) {
            graph.addNode(mapController.usersNodes.first);
          }
          graph.addEdges(mapController.edges);
          return Scaffold(
            appBar: CustomAppBarWidget.appBar(
                title: 'My Family Map'.tr, context: context),
            body: InteractiveViewer(
                minScale: 0.00000001,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(50),
                transformationController: transformationController,
                child: SingleChildScrollView(
                  child: GraphView(
                    builder: (Node node) {
                      if (node.key!.value == 'id' || node.key!.value == 'id2') {
                        return Container();
                      }
                      if (mapController.usersNodes.contains(node)) {
                        keys.add(GlobalKey());
                        return Column(
                          children: [
                            UserPointWidget(
                                id: node.key!.value, treeType: 'auth'),
                          ],
                        );
                      }
                      var a = node.key!.value as String?;
                      return rectangleWidget(a);
                    },
                    graph: graph,
                    algorithm: SugiyamaAlgorithm(builder),
                    paint: Paint()
                      ..color = Colors.green
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                  ),
                )),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                transformationController.value = Matrix4.identity()
                  ..translate(-200.0, 0.0); // translate(x,y);
              },
              child: const Text('me'),
            ),
          );
        });
  }
}

Widget rectangleWidget(String? a) {
  List<String> aa = [
    ...a!.split('*').map(
        (e) => getx.Get.find<UserViewModel>().allFamily.firstWhere((element) {
              print(element.id);
              return element.id == e;
            }).name!)
  ];
  return Container(
      height: 0.0 + userPointHeight,
      width: 0.0 + userPointWidth,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
        ],
      ),
      child: Center(
        child: CustomText(
          size: 12,
          text:
              '${aa[0] == 'Unknown' ? 'Father' : aa[0]} & ${aa[1] == 'Unknown' ? 'Mother' : aa[1]} ',
        ),
      ));
}
