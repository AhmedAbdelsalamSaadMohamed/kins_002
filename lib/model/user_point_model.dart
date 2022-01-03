import '../constant/constants.dart';

class UserPointModel {
  String userId;
  int x;
  int y;

  UserPointModel({required this.userId, required x, required y})
      : this.x = x * (userPointWidth + space),
        this.y = y * (userPointHeight + space * 2);
}
