import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kins_v002/model/user_model.dart';
import 'package:kins_v002/services/firebase/user_firestore.dart';
import 'package:kins_v002/services/sqflite/user_sqflite_database.dart';
import 'package:kins_v002/view/screens/complete_social_sign_up.dart';
import 'package:kins_v002/view/screens/main_screen.dart';
import 'package:kins_v002/view/screens/sign_in_screen.dart';
import 'package:kins_v002/view_model/user_view_model.dart';

class AuthViewModel extends GetxController {
  RxBool loading = false.obs;

  void signInWithFacebook() async {
    loading.value = true;
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final AuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    Future<UserCredential> userCredential =
        FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    userCredential.then((value) async {
      UserModel user;
      if (await emailIsExist(value.user!.email!)) {
        user = (await UserFirestore()
            .getUserFromFirestoreByEmail(value.user!.email!))!;

        Get.find<UserViewModel>()
            .setUserToSharedPreferences(user)
            .then((value) {
          loading.value = false;
          Get.offAll(MainScreen());
        });
      } else {
        user = UserModel(
          id: value.user!.uid.toString(),
          name: value.user!.displayName!,
          email: value.user!.email!,
          profile: value.user!.photoURL,
          gender: 'male',
        );
        loading.value = false;
        Get.to(CompleteSocialSignUp(
          user: user,
        ));
      }
    });
  }

  signInWithGoogle() async {
    loading.value = true;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    Future<UserCredential> userCredential =
        FirebaseAuth.instance.signInWithCredential(credential);

    userCredential.then((value) async {
      UserModel user;
      if (await emailIsExist(value.user!.email!)) {
        user = (await UserFirestore()
            .getUserFromFirestoreByEmail(value.user!.email!))!;
        Get.find<UserViewModel>()
            .setUserToSharedPreferences(user)
            .then((value) {
          Get.offAll(MainScreen());
        });
      } else {
        user = UserModel(
          id: value.user!.uid.toString(),
          name: value.user!.displayName!,
          email: value.user!.email!,
          profile: value.user!.photoURL,
          gender: 'male',
        );
        loading.value = false;
        Get.to(CompleteSocialSignUp(
          user: user,
        ));
      }
    });
  }

  registrationWithEmailAndPassword(UserModel user, String password) async {
    loading.value = true;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email!, password: password)
          .then((value) async {
        user.id = value.user!.uid.toString();
        user.profile = value.user!.photoURL;
        await UserViewModel().setUserToFirestore(user).then((value) async {
          await signInWithEmailAndPassword(user.email!, password);
          loading.value = false;
        });
      });
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      if (e.code == 'user-not-found') {
        Get.defaultDialog(middleText: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.defaultDialog(middleText: 'Wrong password provided for that user.');
      }
    } catch (e) {
      print(e.toString() +
          'ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');
    }
  }

  signInWithEmailAndPassword(String email, String password) async {
    loading.value = true;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) async {
        await UserFirestore()
            .getUserFromFirestoreByEmail(email)
            .then((user) async {
          await Get.find<UserViewModel>()
              .setUserToSharedPreferences(user!)
              .then((value) {
            loading.value = false;
            Get.offAll(MainScreen());
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      loading.value = false;
      if (e.code == 'user-not-found') {
        Get.defaultDialog(middleText: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.defaultDialog(middleText: 'Wrong password provided for that user.');
      }
    }
  }

  Future<bool> signInWithUsernameAndPassword(
      String username, String password) async {
    loading.value = true;
    return await UserFirestore()
        .getUserFromFirestoreByUsername(username)
        .then((user) async {
      loading.value = false;
      if (user != null && user.email != null) {
        await signInWithEmailAndPassword(user.email!, password);
        return true;
      } else {
        print('------$user-----------------------');

        return false;
      }
    });
  }

  signOut() async {
    loading.value = true;
    FirebaseAuth.instance.signOut();
    UserSqfliteDatabase.db.deleteMyDatabase();
    bool result =
        await Get.find<UserViewModel>().clearSharedPreferences().then((value) {
      loading.value = false;
      return value;
    });
    if (result) {
      Get.offAll(SignInScreen());
    }
  }

  Future<bool> usernameIsExist(String username) async {
    loading.value = true;
    return await UserFirestore()
        .getUserFromFirestoreByUsername(username)
        .then((user) {
      loading.value = false;
      if (user == null) {
        return false;
      } else {
        return true;
      }
    });
  }

  Future<bool> emailIsExist(String email) async {
    loading.value = true;
    return await UserFirestore()
        .getUserFromFirestoreByEmail(email)
        .then((user) {
      loading.value = false;
      if (user == null) {
        return false;
      } else {
        return true;
      }
    });
  }
}
