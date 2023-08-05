import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStoragemethods {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // Upload profile pick to cloud storage
  Future<String> uploadprofilepick(Uint8List file) async {
    Reference refe = firebaseStorage
        .ref()
        .child("Profile_pick")
        .child(FirebaseAuth.instance.currentUser!.uid);
    TaskSnapshot reference = await refe.putData(file);
    String downloadableurl = await reference.ref.getDownloadURL();
    return downloadableurl;
  }

  // Upload post to cloud storage
  Future<String> addposttocloudstorage(Uint8List file, String uuid) async {
    Reference refe = firebaseStorage
        .ref()
        .child("User_Posts")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(uuid);
    TaskSnapshot reference = await refe.putData(file);
    String downloadableurl = await reference.ref.getDownloadURL();
    return downloadableurl;
  }
}
