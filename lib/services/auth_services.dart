import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_dumy/widgets/widgets.dart';
import 'package:instagram_dumy/services/cloud_storage.dart';
import 'package:instagram_dumy/services/database_services.dart';

class Authservices {
  String? profilepick;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // *********************************
  // ********* Regiater user *********
  Future<bool> registeruserwithemailandpassword(
    String uname,
    String uemail,
    String upassword,
    Uint8List? pickedimage,
    context,
  ) async {
    try {
      // Calling firebasae inbuilt function
      await firebaseAuth
          .createUserWithEmailAndPassword(
            email: uemail,
            password: upassword,
          )
          .timeout(const Duration(seconds: 5));

      // Setting profile pick
      if (pickedimage != null) {
        profilepick = await CloudStoragemethods().uploadprofilepick(
          pickedimage,
        );
      }

      // Uploading data to database
      await Databaseservice(
        userid: firebaseAuth.currentUser!.uid,
      ).savinguserdatatodatabase(
        uname,
        uemail,
        firebaseAuth.currentUser!.uid,
        profilepick,
      );

      if (kDebugMode) print("User Created Sucessflly🤩");

      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("Sign-up exception😕😕😕");
      if (kDebugMode) print(e.message.toString());
      showsnackbar(context, Colors.red, e);
      Navigator.of(context).pop();
      return false;
    }
  }

  // *********************************
  // *********** Login user **********
  Future<bool> signiuserwithemailandpassword(
    String uemail,
    String upassword,
    context,
  ) async {
    try {
      // Calling firebasae inbuilt function
      await firebaseAuth.signInWithEmailAndPassword(
        email: uemail,
        password: upassword,
      );

      if (kDebugMode) print("User Logedin Sucessflly🤩");

      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("Login exception😕😕😕");
      if (kDebugMode) print(e.message.toString());
      showsnackbar(context, Colors.red, e);
      Navigator.of(context).pop();
      return false;
    }
  }

  // *********************************
  // ********* Google signin *********
  Future<bool> googlesignin(context) async {
    try {
      GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
      if (googleuser != null) {
        GoogleSignInAuthentication googleauth = await googleuser.authentication;
        GoogleAuthProvider.credential(
          accessToken: googleauth.accessToken,
          idToken: googleauth.idToken,
        );
      }
      if (kDebugMode) print("Google Sign-in sucessflly🤩");
      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print("Google exception😕😕😕");
      if (kDebugMode) print(e.message.toString());
      showsnackbar(context, Colors.red, e);
      return false;
    }
  }

  // Sign out
  Future<void> signout(context) async {
    try {
      await firebaseAuth.signOut();
      await GoogleSignIn().signOut();
      if (kDebugMode) print("User Logedout sucessflly");
    } catch (e) {
      showsnackbar(context, Colors.red, e);
    }
  }
}
