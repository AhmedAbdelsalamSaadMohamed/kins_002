import 'package:kins_v002/constant/constants.dart';

class UserModel {
  String? id;
  String? token;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? profile;
  String? spouse;
  String? dad;
  String? mom;
  String? link;

  //List<dynamic>? recommendedPosts;

  UserModel({
    this.id,
    this.token,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.profile,
    this.spouse,
    this.dad,
    this.mom,
    this.link,
    //this.recommendedPosts,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json[fieldId],
        token = json[fieldToken],
        name = json[fieldName],
        email = json[fieldEmail],
        phone = json[fieldPhone],
        gender = json[fieldGender],
        profile = json[fieldProfile],
        spouse = json[fieldSpouse],
        dad = json[fieldDad],
        mom = json[fieldMom],
        link = json[fieldLink];

  toJson() {
    return {
      fieldId: id,
      fieldToken: token,
      fieldName: name,
      fieldEmail: email,
      fieldPhone: phone,
      fieldGender: gender,
      fieldProfile: profile,
      fieldSpouse: spouse,
      fieldDad: dad,
      fieldMom: mom,
      fieldLink: link,
    };
  }

//////////////////////////////////////////////////////////////////////////
  UserModel.fromFire(Map<String, dynamic> json, String userId) {
    id = userId;
    token = json[fieldToken];
    name = json[fieldName];
    email = json[fieldEmail];
    phone = json[fieldPhone];
    gender = json[fieldGender];
    profile = json[fieldProfile];
    spouse = json[fieldSpouse];
    dad = json[fieldDad];
    mom = json[fieldMom];
    link = json[fieldLink];
  }

  toFire() {
    return {
      fieldToken: token,
      fieldName: name,
      fieldEmail: email,
      fieldPhone: phone,
      fieldGender: gender,
      fieldProfile: profile,
      fieldSpouse: spouse,
      fieldDad: dad,
      fieldMom: mom,
      fieldLink: link
    };
  }
////////////////////////////////////////////////////////////////////////////

//  UserModel({
//    this.id,
//    this.name,
//    this.email,
//    this.phone,
//    this.gender,
//    this.profile,
//    this.spouse,
//    this.dad,
//    this.mom,
//  });
//
//  // UserModel.fromSharedPreference(Map<String, dynamic> map)
//  //     : id = map[fieldUserId],
//  //       email = map[fieldEmail],
//  //       firstName = map[fieldFirstName],
//  //       lastName = map[fieldLastName],
//  //       profileImageUrl = map[fieldProfileImageUrl],
//  //       coverImageUrl = map[fieldCoverImageUrl];
//  //
//  // toSharedPreference() {
//  //   return {
//  //     fieldUserId: id,
//  //     fieldEmail: email,
//  //     fieldFirstName: firstName,
//  //     fieldLastName: lastName,
//  //     fieldGender: gender,
//  //     fieldSpouseId: spouseID,
//  //     fieldProfileImageUrl: profileImageUrl,
//  //     fieldCoverImageUrl: coverImageUrl,
//  //   };
// // }
//
//  UserModel.fromJson(Map<dynamic, dynamic> json, String? userId)
//      : id = userId,
//        this.name json[],
//        this.email,
//        this.phone,
//        this.gender,
//        this.profile,
//        this.spouse,
//        this.dad,
//        this.mom,
//
//
//  Map<String, dynamic> toJson() {
//    return {
//      fieldUserId: id,
//      fieldEmail: email,
//      fieldFirstName: firstName,
//      fieldLastName: lastName,
//      fieldGender: gender,
//      fieldSpouseId: spouseID,
//      fieldProfileImageUrl: profileImageUrl,
//      fieldCoverImageUrl: coverImageUrl,
//      fieldDadId: dadId,
//      fieldMomId: momId,
//      listSons: sons,
//    };
//  }
}
