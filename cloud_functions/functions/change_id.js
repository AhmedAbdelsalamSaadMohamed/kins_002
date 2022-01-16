const functions =require("firebase-functions");
const admin =require("firebase-admin");
exports.changeIdFun = functions.https.onCall((data, context) => {
  const oldId =data.old;
  const newId =data.new;
  functions.logger.log("oldId "+oldId);
  functions.logger.log("newId "+newId);
  admin.firestore().collection("users").get().then((users)=>{
    users.docs.forEach((user)=>{
      functions.logger.log("userId "+user.data().id);
      admin.firestore().collection("users").doc(user.id).
          collection("family").doc(oldId).delete().then((value)=>{
            admin.firestore().collection("users").doc(user.id)
                .collection("family").doc(newId).set({});
          });
      if (user.data().dad === oldId) {
        // eslint-disable-next-line max-len
        admin.firestore().collection("users").doc(user.id).update({"dad": newId});
      }
      if (user.data().mom === oldId) {
        // eslint-disable-next-line max-len
        admin.firestore().collection("users").doc(user.id).update({"mom": newId});
      }
      if (user.data().spouse === oldId) {
        // eslint-disable-next-line max-len
        admin.firestore().collection("users").doc(user.id).update({"spouse": newId});
      }
    });
  });
});
