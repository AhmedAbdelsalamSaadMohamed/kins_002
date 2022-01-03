import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  Future<String> uploadFile(File file) async {
    return await FirebaseStorage.instance
        .ref()
        .child('uploads/${file.path}')
        .putFile(file)
        .then((taskSnapshot) {
      return taskSnapshot.ref.getDownloadURL();
    });
  }
}
