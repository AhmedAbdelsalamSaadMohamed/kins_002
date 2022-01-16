import 'package:get/get.dart';
import 'package:kins_v002/model/request_model.dart';
import 'package:kins_v002/services/firebase/request_firestore.dart';

class RequestViewModel extends GetxController {
  RequestFireStore requestFireStore = RequestFireStore();

  addRequest(RequestModel request) {
    requestFireStore.addRequest(request);
  }

  Stream<int> getRequestsToMeCount() {
    return requestFireStore.getRequestsToMeCount();
  }

  Stream<int> getRequestsFromMeCount() {
    return requestFireStore.getRequestsFromMeCount();
  }

  Stream<List<RequestModel>> getRequestsFromMe() {
    return requestFireStore.getRequestsFromMe();
  }

  Stream<List<RequestModel>> getRequestsToMe() {
    return requestFireStore.getRequestsToMe();
  }

  deleteRequest(RequestModel request) {
    requestFireStore.deleteRequest(request);
    //userController.getAllFamily();
  }

  acceptRequest(RequestModel request) {
    requestFireStore.acceptRequest(request);
  }
}
