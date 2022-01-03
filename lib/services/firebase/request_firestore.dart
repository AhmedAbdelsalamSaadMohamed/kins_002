import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/request_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class RequestFireStore {
  UserModel currentUser = Get.find<UserViewModel>().currentUser!;
  UserViewModel userController = Get.find<UserViewModel>();

  addRequest(String userId, RequestModel request) {
    FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(userId)
        .collection(collectionRequests)
        .add(
          request.toFire(),
        );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRequestsStream() {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(currentUser.id)
        .collection(collectionRequests)
        .snapshots();
  }

  deleteRequest(RequestModel request) {
    /// delete request
    FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(request.userId)
        .collection(collectionRequests)
        .where(fieldRequestRelationId, isEqualTo: request.relationId)
        .get()
        .then((value) => FirebaseFirestore.instance
            .collection(tableUsers)
            .doc(request.userId)
            .collection(collectionRequests)
            .doc(value.docs.first.id)
            .delete());

    /// delete user
    FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(request.relationId)
        .delete();

    /// mom
    FirebaseFirestore.instance
        .collection(tableUsers)
        .where(fieldMom, isEqualTo: request.relationId)
        .get()
        .then((value) {
      value.docs.forEach((user) {
        FirebaseFirestore.instance
            .collection(tableUsers)
            .doc(request.userId)
            .collection(collectionRequests)
            .doc(user.id)
            .update({fieldMom: null});
      });
    });

    /// dad
    FirebaseFirestore.instance
        .collection(tableUsers)
        .where(fieldDad, isEqualTo: request.relationId)
        .get()
        .then((value) {
      value.docs.forEach((user) {
        FirebaseFirestore.instance
            .collection(tableUsers)
            .doc(request.userId)
            .collection(collectionRequests)
            .doc(user.id)
            .update({fieldDad: null});
      });
    });

    /// spouse
    FirebaseFirestore.instance
        .collection(tableUsers)
        .where(fieldSpouse, isEqualTo: request.relationId)
        .get()
        .then((value) {
      value.docs.forEach((user) {
        FirebaseFirestore.instance
            .collection(tableUsers)
            .doc(request.userId)
            .collection(collectionRequests)
            .doc(user.id)
            .update({fieldSpouse: null});
      });
    });
  }

  acceptRequest(RequestModel request) async {
    await userController.getUserFromFireStore(request.userId!).then((user) =>
        userController
            .getUserFromFireStore(request.relationId!)
            .then((relation) {
          user!.dad = relation!.dad ?? user.dad;
          user.mom = relation.mom ?? user.mom;
          user.spouse = relation.spouse ?? user.spouse;
          userController.setUserToFirestore(user);
          userController.deleteUserFromFireStore(request.relationId!);
        }));

    /// mom
    FirebaseFirestore.instance
        .collection(tableUsers)
        .where(fieldMom, isEqualTo: request.relationId)
        .get()
        .then((value) {
      value.docs.forEach((user) {
        FirebaseFirestore.instance
            .collection(tableUsers)
            .doc(request.userId)
            .collection(collectionRequests)
            .doc(user.id)
            .update({fieldMom: request.userId});
      });
    });

    /// dad
    FirebaseFirestore.instance
        .collection(tableUsers)
        .where(fieldDad, isEqualTo: request.relationId)
        .get()
        .then((value) {
      value.docs.forEach((user) {
        FirebaseFirestore.instance
            .collection(tableUsers)
            .doc(request.userId)
            .collection(collectionRequests)
            .doc(user.id)
            .update({fieldDad: request.userId});
      });
    });

    /// spouse
    FirebaseFirestore.instance
        .collection(tableUsers)
        .where(fieldSpouse, isEqualTo: request.relationId)
        .get()
        .then((value) {
      value.docs.forEach((user) {
        FirebaseFirestore.instance
            .collection(tableUsers)
            .doc(request.userId)
            .collection(collectionRequests)
            .doc(user.id)
            .update({fieldSpouse: request.userId});
      });
    });

    /// delete request
    FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(request.userId)
        .collection(collectionRequests)
        .where(fieldRequestRelationId, isEqualTo: request.relationId)
        .get()
        .then((value) => FirebaseFirestore.instance
            .collection(tableUsers)
            .doc(request.userId)
            .collection(collectionRequests)
            .doc(value.docs.first.id)
            .delete());
  }
}
