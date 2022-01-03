import '../constant/constants.dart';
import 'line_model.dart';
import 'point_model.dart';
import 'user_point_model.dart';

class UserLineModel {
  final UserPointModel point1, point2;
  PointModel? startPoint, endPoint;
  final List<LineModel> _lines = [];

  List<LineModel> get lines {
    return _lines;
  }

  ///'wife'  or 'son'
  String? _state;

  UserLineModel(this.point1, this.point2) {
    _init();
    if (_state == 'wife') {
      _wifeLine();
    } else {
      _sonLine();
    }
  }

  _init() {
    if (point1.y == point2.y && point1.x < point2.x) {
      startPoint = PointModel(
          x: (point1.x + userPointWidth),
          y: (point1.y + (userPointHeight ~/ 2)));
      endPoint = PointModel(x: point2.x, y: (point2.y + userPointHeight ~/ 2));
      _state = 'wife';
    } else if (point1.y == point2.y && point2.x < point1.x) {
      startPoint = PointModel(
          x: (point2.x + userPointWidth), y: (point2.y + userPointHeight ~/ 2));
      endPoint = PointModel(x: point1.x, y: (point1.y + userPointHeight ~/ 2));
      _state = 'wife';
    } else if (point1.y < point2.y) {
      startPoint = PointModel(
          x: (point1.x + userPointWidth + space ~/ 2),
          y: (point1.y + userPointHeight ~/ 2));
      endPoint = PointModel(x: (point2.x + userPointWidth ~/ 2), y: point2.y);
      _state = 'son';
    } else {
      startPoint = PointModel(
          x: (point2.x + userPointWidth + space ~/ 2),
          y: (point2.y + userPointHeight ~/ 2));
      endPoint = PointModel(x: (point1.x + userPointWidth ~/ 2), y: point1.y);
      _state = 'son';
    }
  }

  _wifeLine() {
    lines.add(LineModel(point1: startPoint!, point2: endPoint!));
  }

  _sonLine() {
    PointModel _newPoint0 = PointModel(x: startPoint!.x, y: (startPoint!.y));
    PointModel _newPoint1 = PointModel(
        x: startPoint!.x, y: (startPoint!.y + space + userPointHeight ~/ 2));
    PointModel _newPoint2 =
        PointModel(x: endPoint!.x, y: (endPoint!.y - space));

    lines.add(LineModel(point1: _newPoint0, point2: _newPoint1));
    lines.add(LineModel(point1: _newPoint1, point2: _newPoint2));
    lines.add(LineModel(point1: _newPoint2, point2: endPoint!));
  }
}
