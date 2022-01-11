import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kins_v002/constant/constants.dart';

class RequestModel {
  String? id;
  String? senderId;
  String? userId;
  Relations? relation;
  Timestamp? time;

  RequestModel({this.id, this.senderId, this.userId, this.relation, this.time});

  RequestModel.fromFire(Map<String, dynamic> map, this.id)
      : senderId = map[fieldRequestSenderId],
        userId = map[fieldRequestUserId],
        relation = Relations.values.firstWhere(
            (element) => element.name == map[fieldRequestRelationId]),
        time = map[fieldRequestTime];

  Map<String, dynamic> toFire() =>
      {
        fieldRequestId: id,
        fieldRequestSenderId: senderId,
        fieldRequestUserId: userId,
        fieldRequestRelationId: relation!.name,
        fieldRequestTime: time
      };
}
