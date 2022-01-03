import 'package:flutter/cupertino.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view/tree_widgets/user_point_widget.dart';

class PositionedUserPointWidget extends StatelessWidget {
  PositionedUserPointWidget(
      {Key? key,
      required this.id,
      required this.x,
      required this.y,
      this.isTreeOwner = false,
      required this.treeType})
      : super(key: key);
  final double x, y;
  bool isTreeOwner;
  late UserModel user;
  String id, treeType;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: x,
        top: y,
        child: UserPointWidget(
          id: id,
          treeType: treeType,
          isTreeOwner: isTreeOwner,
        ));
  }
}
