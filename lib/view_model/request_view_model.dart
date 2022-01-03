import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/model/request_model.dart';
import 'package:kins_v002/services/firebase/request_firestore.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class RequestViewModel extends GetxController {
  UserViewModel userController = Get.find<UserViewModel>();
  RequestFireStore requestFireStore = RequestFireStore();

  addRequest(RequestModel request) {
    requestFireStore.addRequest(request.userId!, request);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRequestsStream() {
    // requestFireStore
    //     .getRequestsStream()
    //     .last
    //     .then((value) => value.docs.forEach((request) async {
    //           UserModel user = (await userController
    //               .getUserFromFireStore(request[fieldRequestRelationId]))!;
    //           if (!userController.allFamily.contains(user)) {
    //             userController.getParents(user);
    //             userController.getSons(user);
    //           }
    //         }));
    return requestFireStore.getRequestsStream();
  }

  deleteRequest(RequestModel request) {
    requestFireStore.deleteRequest(request);
    userController.getAllFamily();
  }

  acceptRequest(RequestModel request) {
    requestFireStore.acceptRequest(request);
  }
}
