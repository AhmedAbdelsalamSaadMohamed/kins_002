import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/request_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class RequestFireStore {
  UserModel currentUser = Get.find<UserViewModel>().currentUser!;
  UserViewModel userController = Get.find<UserViewModel>();

  addRequest(RequestModel request) {
    /// to user
    FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(request.userId)
        .collection(collectionRequestsToMe)
        .doc(request.senderId! + request.userId!)
        .set(
          request.toFire(),
        );

    /// from me
    FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(currentUser.id)
        .collection(collectionRequestsFromMe)
        .add(
          request.toFire(),
        );
  }

  Stream<List<RequestModel>> getRequestsToMe() {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(currentUser.id)
        .collection(collectionRequestsToMe)
        .snapshots()
        .map((event) =>
            [...event.docs.map((e) => RequestModel.fromFire(e.data(), e.id))]);
  }

  Stream<List<RequestModel>> getRequestsFromMe() {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(currentUser.id)
        .collection(collectionRequestsFromMe)
        .snapshots()
        .map((event) =>
            [...event.docs.map((e) => RequestModel.fromFire(e.data(), e.id))]);
  }

  deleteRequest(RequestModel request) {
    // /// delete request
    // FirebaseFirestore.instance
    //     .collection(tableUsers)
    //     .doc(request.userId)
    //     .collection(collectionRequests)
    //     .where(fieldRequestRelationId, isEqualTo: request.relation)
    //     .get()
    //     .then((value) => FirebaseFirestore.instance
    //         .collection(tableUsers)
    //         .doc(request.userId)
    //         .collection(collectionRequests)
    //         .doc(value.docs.first.id)
    //         .delete());
    //
    // /// delete user
    // FirebaseFirestore.instance
    //     .collection(tableUsers)
    //     .doc(request.id)
    //     .delete();
    //
    // /// mom
    // FirebaseFirestore.instance
    //     .collection(tableUsers)
    //     .where(fieldMom, isEqualTo: request.relation)
    //     .get()
    //     .then((value) {
    //   value.docs.forEach((user) {
    //     FirebaseFirestore.instance
    //         .collection(tableUsers)
    //         .doc(request.userId)
    //         .collection(collectionRequests)
    //         .doc(user.id)
    //         .update({fieldMom: null});
    //   });
    // });
    //
    // /// dad
    // FirebaseFirestore.instance
    //     .collection(tableUsers)
    //     .where(fieldDad, isEqualTo: request.relation)
    //     .get()
    //     .then((value) {
    //   value.docs.forEach((user) {
    //     FirebaseFirestore.instance
    //         .collection(tableUsers)
    //         .doc(request.userId)
    //         .collection(collectionRequests)
    //         .doc(user.id)
    //         .update({fieldDad: null});
    //   });
    // });
    //
    // /// spouse
    // FirebaseFirestore.instance
    //     .collection(tableUsers)
    //     .where(fieldSpouse, isEqualTo: request.relation)
    //     .get()
    //     .then((value) {
    //   value.docs.forEach((user) {
    //     FirebaseFirestore.instance
    //         .collection(tableUsers)
    //         .doc(request.userId)
    //         .collection(collectionRequests)
    //         .doc(user.id)
    //         .update({fieldSpouse: null});
    //   });
    // });
  }

  acceptRequest(RequestModel request) async {
    //
    // await userController.getUserFromFireStore(request.userId!).then((user) =>
    //     userController
    //         .getUserFromFireStore(request.relation!)
    //         .then((relation) {
    //       user!.dad = relation!.dad ?? user.dad;
    //       user.mom = relation.mom ?? user.mom;
    //       user.spouse = relation.spouse ?? user.spouse;
    //       userController.setUserToFirestore(user);
    //       userController.deleteUserFromFireStore(request.relation!);
    //     }));
    //
    // /// mom
    // FirebaseFirestore.instance
    //     .collection(tableUsers)
    //     .where(fieldMom, isEqualTo: request.relation)
    //     .get()
    //     .then((value) {
    //   value.docs.forEach((user) {
    //     FirebaseFirestore.instance
    //         .collection(tableUsers)
    //         .doc(request.userId)
    //         .collection(collectionRequests)
    //         .doc(user.id)
    //         .update({fieldMom: request.userId});
    //   });
    // });
    //
    // /// dad
    // FirebaseFirestore.instance
    //     .collection(tableUsers)
    //     .where(fieldDad, isEqualTo: request.relation)
    //     .get()
    //     .then((value) {
    //   value.docs.forEach((user) {
    //     FirebaseFirestore.instance
    //         .collection(tableUsers)
    //         .doc(request.userId)
    //         .collection(collectionRequests)
    //         .doc(user.id)
    //         .update({fieldDad: request.userId});
    //   });
    // });
    //
    // /// spouse
    // FirebaseFirestore.instance
    //     .collection(tableUsers)
    //     .where(fieldSpouse, isEqualTo: request.relation)
    //     .get()
    //     .then((value) {
    //   value.docs.forEach((user) {
    //     FirebaseFirestore.instance
    //         .collection(tableUsers)
    //         .doc(request.userId)
    //         .collection(collectionRequests)
    //         .doc(user.id)
    //         .update({fieldSpouse: request.userId});
    //   });
    // });
    //
    // /// delete request
    // FirebaseFirestore.instance
    //     .collection(tableUsers)
    //     .doc(request.userId)
    //     .collection(collectionRequests)
    //     .where(fieldRequestRelationId, isEqualTo: request.relation)
    //     .get()
    //     .then((value) => FirebaseFirestore.instance
    //         .collection(tableUsers)
    //         .doc(request.userId)
    //         .collection(collectionRequests)
    //         .doc(value.docs.first.id)
    //         .delete());
  }
}
