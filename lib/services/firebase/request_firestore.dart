import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:kins_v002/constant/constants.dart';
import 'package:kins_v002/model/request_model.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/services/firebase/family_firestore.dart';
import 'package:kins_v002/services/firebase/user_firestore.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class RequestFireStore {
  UserModel _currentUser = Get.find<UserViewModel>().currentUser!;
  FamilyFireStore _familyFireStore = FamilyFireStore();
  UserFirestore _userFirestore = UserFirestore();

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
        .doc(request.senderId)
        .collection(collectionRequestsFromMe)
        .doc(request.senderId! + request.userId!)
        .set(
          request.toFire(),
        );
  }

  deleteRequest(RequestModel request) {
    /// to user
    FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(request.userId)
        .collection(collectionRequestsToMe)
        .doc(request.senderId! + request.userId!)
        .delete();

    /// from me
    FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(request.senderId)
        .collection(collectionRequestsFromMe)
        .doc(request.senderId! + request.userId!)
        .delete();
  }

  Stream<List<RequestModel>> getRequestsToMe() {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(_currentUser.id)
        .collection(collectionRequestsToMe)
        .snapshots()
        .map((event) =>
            [...event.docs.map((e) => RequestModel.fromFire(e.data(), e.id))]);
  }

  Stream<int> getRequestsToMeCount() {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(_currentUser.id)
        .collection(collectionRequestsToMe)
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<List<RequestModel>> getRequestsFromMe() {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(_currentUser.id)
        .collection(collectionRequestsFromMe)
        .snapshots()
        .map((event) =>
            [...event.docs.map((e) => RequestModel.fromFire(e.data(), e.id))]);
  }

  Stream<int> getRequestsFromMeCount() {
    return FirebaseFirestore.instance
        .collection(tableUsers)
        .doc(_currentUser.id)
        .collection(collectionRequestsFromMe)
        .snapshots()
        .map((event) => event.docs.length);
  }

  ///    ////////////////////////////////
  acceptRequest(RequestModel request) async {
    deleteRequest(request);
    switch (request.relation!) {
      case Relations.myDad:
        {
          _familyFireStore.addToFamily(userId: request.senderId!);
          _userFirestore.getUser(request.senderId!).then((sender) {
            if (sender!.dad != null) {
              _userFirestore.deleteUserFromFirestore(sender.dad!);
              _changeId(oldId: sender.dad!, newId: _currentUser.id!);
            }
            if (sender.mom == null) {
              UserModel senderMom = UserModel(
                id: 'NULLmom${sender.id}',
                gender: 'female',
              );
              _userFirestore.setUser(senderMom);
              sender.mom = senderMom.id;
              _userFirestore.setUser(sender);
              _familyFireStore.addToFamily(userId: senderMom.id!);
            }
            sender.dad = _currentUser.id;
            _userFirestore.setUser(sender);
          });
        }
        break;
      case Relations.myMom:
        {
          _familyFireStore.addToFamily(userId: request.senderId!);
          _userFirestore.getUser(request.senderId!).then((sender) {
            if (sender!.mom != null) {
              _userFirestore.deleteUserFromFirestore(sender.mom!);
              _changeId(oldId: sender.mom!, newId: _currentUser.id!);
            }
            if (sender.dad == null) {
              UserModel senderDad = UserModel(
                id: 'NULLdad${sender.id}',
                gender: 'male',
              );
              _userFirestore.setUser(senderDad);
              sender.dad = senderDad.id;
              _userFirestore.setUser(sender);
              _familyFireStore.addToFamily(userId: senderDad.id!);
            }
            sender.mom = _currentUser.id;
            _userFirestore.setUser(sender);
          });
        }
        break;
      case Relations.mySon:
        _sonOrDaughterAcceptRelation(request);
        break;
      case Relations.myDaughter:
        _sonOrDaughterAcceptRelation(request);
        break;
      case Relations.myHusband:
        {
          _familyFireStore.addToFamily(userId: request.senderId!);
          _userFirestore.getUser(request.senderId!).then((value) {
            value!.spouse = _currentUser.id;
            _userFirestore.setUser(value);
          });
          _userFirestore.getUser(_currentUser.id!).then((value) {
            value!.spouse = request.senderId;
            _userFirestore.setUser(value);
          });
        }
        break;
      case Relations.myWife:
        {
          _familyFireStore.addToFamily(userId: request.senderId!);
          _userFirestore.getUser(request.senderId!).then((value) {
            value!.spouse = _currentUser.id;
            _userFirestore.setUser(value);
          });
          _userFirestore.getUser(_currentUser.id!).then((value) {
            value!.spouse = request.senderId;
            _userFirestore.setUser(value);
          });
        }
        break;
      case Relations.myBrother:
        {
          _familyFireStore.addToFamily(userId: request.senderId!);
          _userFirestore.getUser(request.senderId!).then((sender) {
            _sisterORBrotherAcceptRelation(sender!);
          });
        }
        break;
      case Relations.mySister:
        {
          _familyFireStore.addToFamily(userId: request.senderId!);
          _userFirestore.getUser(request.senderId!).then((sender) {
            _sisterORBrotherAcceptRelation(sender!);
          });
        }
        break;
      case Relations.myMaternalUncle:
        _familyFireStore.addToFamily(userId: request.senderId!);
        _userFirestore.getUser(request.senderId!).then((sender) {
          _familyFireStore.addToFamily(userId: sender!.mom!);
          _userFirestore.getUser(sender.mom!).then((senderMom) {
            _familyFireStore.addToFamily(userId: senderMom!.id!);
            _sisterORBrotherAcceptRelation(senderMom);
          });
        });
        break;
      case Relations.myUncle:
        {
          _familyFireStore.addToFamily(userId: request.senderId!);
          _userFirestore.getUser(request.senderId!).then((sender) {
            _familyFireStore.addToFamily(userId: sender!.dad!);
            _userFirestore.getUser(sender.dad!).then((senderDad) {
              _familyFireStore.addToFamily(userId: senderDad!.id!);
              _sisterORBrotherAcceptRelation(senderDad);
            });
          });
        }
        break;
      case Relations.myMaternalAunt:
        _familyFireStore.addToFamily(userId: request.senderId!);
        _userFirestore.getUser(request.senderId!).then((sender) {
          _familyFireStore.addToFamily(userId: sender!.mom!);
          _userFirestore.getUser(sender.mom!).then((senderMom) {
            _familyFireStore.addToFamily(userId: senderMom!.id!);
            _sisterORBrotherAcceptRelation(senderMom);
          });
        });
        break;
      case Relations.myAunt:
        _familyFireStore.addToFamily(userId: request.senderId!);
        _userFirestore.getUser(request.senderId!).then((sender) {
          _familyFireStore.addToFamily(userId: sender!.dad!);
          _userFirestore.getUser(sender.dad!).then((senderDad) {
            _sisterORBrotherAcceptRelation(senderDad!);
            _familyFireStore.addToFamily(userId: senderDad!.id!);
          });
        });
        break;
    }
  }

  _sisterORBrotherAcceptRelation(UserModel sender) {
    /// if dad sender and receiver null
    if (sender.dad == null && _currentUser.dad == null) {
      UserModel newDad = UserModel(
        id: 'NULLdad${_currentUser.id}',
        gender: 'male',
      );
      _userFirestore.setUser(newDad);
      _currentUser.dad = newDad.id;
      _userFirestore.setUser(_currentUser);
      sender.dad = newDad.id;
      _userFirestore.setUser(sender);
      _familyFireStore.addToFamily(userId: newDad.id!);
    }

    /// if  dad of receiver real user
    else if (!(sender.dad?.startsWith('NULL') ?? true)) {
      _currentUser.dad = sender.dad;
      _userFirestore.setUser(_currentUser);
    }

    /// if dad of sender real user
    else if (!(_currentUser.dad?.startsWith('NULL') ?? true)) {
      sender.dad = _currentUser.dad;
      _userFirestore.setUser(sender);
    }

    /// if dad of sender and receiver  not real users
    else if ((sender.dad?.startsWith('NULL') ?? true) &&
        (_currentUser.dad?.startsWith('NULL') ?? true)) {
      _changeId(oldId: _currentUser.dad!, newId: sender.dad!);
      _currentUser.dad = sender.dad;
      _userFirestore.setUser(_currentUser);
    }

    /// if dad of sender ==null
    else if (sender.dad == null) {
      sender.dad = sender.dad;
      _userFirestore.setUser(sender);
    }

    /// if dad of receiver  ==null
    else if (_currentUser.dad == null) {
      _currentUser.dad = sender.dad;
      _userFirestore.setUser(_currentUser);
    }
    //
    // else {
    //   _userFirestore.setUser(UserModel(
    //     id: 'NULLdad${_currentUser.id}',
    //     gender: 'male',
    //   ));
    //   _familyFireStore.addToFamily(userId: 'NULLdad${_currentUser.id}');
    //   _currentUser.dad = 'NULLdad${_currentUser.id}';
    //   _userFirestore.setUser(_currentUser);
    //   sender.dad = 'NULLdad${_currentUser.id}';
    //   _userFirestore.setUser(sender);
    // }
    /// ////////////////////////////////////////////////////////////////////////////////////
    ///
    /// if mom sender and receiver null
    if (sender.mom == null && _currentUser.mom == null) {
      UserModel newMom = UserModel(
        id: 'NULLmom${_currentUser.id}',
        gender: 'female',
      );
      _userFirestore.setUser(newMom);
      _currentUser.mom = newMom.id;
      _userFirestore.setUser(_currentUser);
      sender.mom = newMom.id;
      _userFirestore.setUser(sender);
      _familyFireStore.addToFamily(userId: newMom.id!);
    }

    /// if  mom of receiver real user
    else if (!(sender.mom?.startsWith('NULL') ?? true)) {
      _currentUser.mom = sender.mom;
      _userFirestore.setUser(_currentUser);
    }

    /// if dad of sender real user
    else if (!(_currentUser.mom?.startsWith('NULL') ?? true)) {
      sender.mom = _currentUser.mom;
      _userFirestore.setUser(sender);
    }

    /// if mom of sender and receiver  not real users
    else if ((sender.mom?.startsWith('NULL') ?? true) &&
        (_currentUser.mom?.startsWith('NULL') ?? true)) {
      _changeId(oldId: _currentUser.mom!, newId: sender.mom!);
      _currentUser.mom = sender.mom;
      _userFirestore.setUser(_currentUser);
    }

    /// if mom of sender ==null
    else if (sender.mom == null) {
      sender.mom = sender.mom;
      _userFirestore.setUser(sender);
    }

    /// if dad of receiver  ==null
    else if (_currentUser.mom == null) {
      _currentUser.mom = sender.mom;
      _userFirestore.setUser(_currentUser);
    }

    ///
  }

  _sonOrDaughterAcceptRelation(RequestModel request) {
    _familyFireStore.addToFamily(userId: request.senderId!);
    _userFirestore.getUser(request.senderId!).then((sender) {
      _userFirestore.getUser(_currentUser.id!).then((receiver) {
        if (sender?.gender == 'male') {
          if (receiver!.dad != null) {
            _userFirestore.deleteUserFromFirestore(receiver.dad!);
            _changeId(oldId: receiver.dad!, newId: request.userId!);
          }
          receiver.dad = request.userId;
          if (receiver.mom == null) {
            UserModel receiverMom = UserModel(
              id: 'NULLmom${receiver.id}',
              gender: 'female',
            );
            _userFirestore.setUser(receiverMom);
            receiver.mom = receiverMom.id;
            _userFirestore.setUser(receiver);
            _familyFireStore.addToFamily(userId: receiverMom.id!);
          }
        } else {
          if (receiver!.mom != null) {
            _userFirestore.deleteUserFromFirestore(receiver.mom!);
            _changeId(oldId: receiver.mom!, newId: request.userId!);
          }
          receiver.mom = request.userId;
          if (receiver.dad == null) {
            UserModel receiverDad = UserModel(
              id: 'NULLdad${receiver.id}',
              gender: 'male',
            );
            _userFirestore.setUser(receiverDad);
            receiver.dad = receiverDad.id;
            _userFirestore.setUser(receiver);
            _familyFireStore.addToFamily(userId: receiverDad.id!);
          }
        }
        _userFirestore.setUser(receiver);
      });
    });
  }
}

///
Future<void> _changeId({required String oldId, required String newId}) async {
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('changeId');
  final resp = await callable.call(<String, dynamic>{
    "old": oldId,
    "new": newId,
  });
  print('result = ${resp.data}');
}
