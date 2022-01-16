import 'package:flutter/material.dart';
import 'package:kins_v002/model/line_model.dart';

class LineWidget extends StatelessWidget {
  LineWidget({Key? key, required this.line})
      : _startX = 0.0 + line.point1.x,
        _startY = 0.0 + line.point1.y,
        _endX = 0.0 + line.point2.x,
        _endY = 0.0 + line.point2.y;
  final double _startX, _startY, _endX, _endY;
  final LineModel line;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(color: Theme.of(context).colorScheme.secondary),
      clipper: MyCustomClipper(_startX, _startY, _endX, _endY),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  MyCustomClipper(this.startX, this.startY, this.endX, this.endY);

  final double startX, startY, endX, endY;

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(startX, startY);
    path.lineTo(endX, endY);
    path.lineTo(endX + 1, endY + 1);
    path.lineTo(startX + 1, startY + 1);
    path.lineTo(startX, startY);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
