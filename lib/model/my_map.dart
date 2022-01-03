// import 'package:flutter/material.dart';
// import 'package:kins_v002/constants.dart';
// import 'package:kins_v002/view/tree_widgets/line_widget.dart';
// import 'package:kins_v002/view/tree_widgets/user_point_widget.dart';
//
// class MyMap {
//   final double mainX;
//   final double mainY;
//   final Gender gender;
//
//   MyMap({required this.mainX, required this.mainY, required this.gender,});
//
//   MyMap.fromPoint(PointElement point, { required this.gender})
//       : mainX = point.x,
//         mainY = point.y;
//
//   Widget paintMain() {
//     return PointElement(x: mainX, y: mainY);
//   }
//
//   List<Widget> paintWife() {
//     double newX = mainX + pointWidth + wSpace,
//         startX = mainX + pointWidth,
//         startY = mainY +(pointHeight / 2),
//         endX = startX + wSpace,
//         endY = startY;
//
//     Line line = Line(startX: startX, startY: startY, endX: endX, endY: endY);
//     return [PointElement(x: newX, y:
//     mainY
//     ),line
//
//     ];
//   }
//
//   // List<Widget> paintHusband() {
//   //   double newX = mainX - wSpace-pointWidth,
//   //       startX = mainX ,
//   //       startY = mainY +(pointHeight / 2),
//   //       endX = startX - wSpace,
//   //       endY = startY;
//   //   Line line = Line(startX: startX, startY: startY, endX: endX, endY: endY);
//   //   return [PointElement(x: 0.0+newX, y: mainY),line ];
//   // }
//
//   paintParents({centerXc  } ){
//
//
//   }
//
//
// }
