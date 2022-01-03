//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:kins_v002/constant/constants.dart';
// import 'package:kins_v002/model/my_map.dart';
// import 'package:kins_v002/model/user_line_model.dart';
// import 'package:kins_v002/view/tree_widgets/positioned_user_point_widget.dart';
// import 'package:kins_v002/view/tree_widgets/user_point_widget.dart';
// import 'package:kins_v002/view_model/build_tree_view_model.dart';
// import 'package:zoom_widget/zoom_widget.dart';
//
// import 'line_widget.dart';
//
// class MapWidget extends StatefulWidget {
//   const MapWidget({Key? key}) : super(key: key);
//
//   @override
//   _MapWidgetState createState() => _MapWidgetState();
// }
//
// class _MapWidgetState extends State<MapWidget> {
//   var _centerKey = GlobalKey();
//
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       setState(() {
//         final ctx = _centerKey.currentContext;
//         //Scrollable.ensureVisible(ctx!, alignment: 0.5);
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double mapWidth = 2000;
//     double mapHeight = 2000;
//     // MyMap myMap =
//     //     MyMap(mainX: mapWidth / 2, mainY: mapHeight / 2, gender: Gender.male);
//     return Zoom(
//         maxZoomHeight: 2000,
//        maxZoomWidth: 2000,
//        opacityScrollBars: 0.05,
//        backgroundColor: Colors.white,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Container(
//             width: mapWidth,
//             height: mapHeight,
//             color: Colors.deepOrangeAccent,
//             child: Stack(
//               children: [
//                 Container(
//                   width: mapWidth+5000,
//                   height: mapHeight,
//                   color: Colors.white,
//                 ),
//                 Positioned(
//                   key: _centerKey,
//                   top: 750,
//                   left: 750,
//                   child: Container(
//                     width: 50,
//                     height: 50,
//                     color: Colors.brown,
//                   ),
//                 ),
//                 ...[
//                   ...BuildTreeViewModel().userPoints.map((e) => PositionedUserPointWidget(id: e.userId,x:0.0+ e.x , y: 0.0+e.y, treeType: 'auth',))
//                 ],
//                 ...[
//                   ...BuildTreeViewModel().userLines.map((e) => LineWidget(line: e))
//                 ],
//
//                 // myMap.paintMain()
//                 // ...myMap.paintHusband(),
//                 ClipPath(
//                   child: Container(color: Colors.blue),
//                   clipper: MyCustomClipper(),
//                 ),
//                 //LineWidget(startX: 100, startY: 100, endX: 2200, endY: 200),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MyCustomClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var centerX = 400.0;
//     var centerY = 400.0;
//     Path path = Path();
//     path.lineTo(centerX, centerY);
//     path.lineTo(centerX + 100, centerY);
//     path.lineTo(centerX + 100, centerY + 10);
//     path.lineTo(centerX, centerY + 10);
//     path.lineTo(centerX, centerY);
//     return path;
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     // TODO: implement shouldReclip
//     return false;
//   }
// }
