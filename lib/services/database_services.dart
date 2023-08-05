import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_dumy/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_dumy/models/user_model.dart';
import 'package:instagram_dumy/models/posts_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_dumy/models/comments_model.dart';

class Databaseservice {
  final String? userid;
  Databaseservice({this.userid});

  // Collection Reference
  CollectionReference userreference = FirebaseFirestore.instance.collection(
    "Users_data",
  );
  CollectionReference postreference = FirebaseFirestore.instance.collection(
    "Users_posts",
  );

  // **************************************************
  // ********** Saving user data to Database **********
  Future<void> savinguserdatatodatabase(
    String name,
    String email,
    String uid,
    String? profilepick,
  ) async {
    profilepick ??= "";

    // Saving data to usermodel
    final Usermodel usermodel = Usermodel(
      name: name,
      email: email,
      profilepick: profilepick,
      uid: uid,
      bio: "",
      followers: [],
      following: [],
    );

    // Saving data to Firestore Database
    await userreference.doc(uid).set(usermodel.tojson());
    if (kDebugMode) print("User logined data saved🤩");
  }

  // **************************************************
  // ******* Saving user-post data to database ********
  Future<void> saveuserpostdata(String uuid, Postmodel postmodel) async {
    await postreference
        .doc("${FirebaseAuth.instance.currentUser!.uid}_$uuid")
        .set(postmodel.tojson());
    if (kDebugMode) print("User post data saved🤩");
  }

  // **************************************************
  // ******** Getting user data from database *********
  Future<Usermodel> gettingusersalldata() async {
    DocumentSnapshot documentSnapshot =
        await userreference.doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (kDebugMode) print("Sucessfully called database🤩");

    return Usermodel.datasnapshot(documentSnapshot);
  }

  // **************************************************
  // ***************** Add User Likes *****************
  Future<void> likePost(
    String postid,
    String userid,
    List likes,
    context,
  ) async {
    try {
      if (likes.contains(userid)) {
        await postreference.doc(postid).update({
          "Likes": FieldValue.arrayRemove([userid])
        });
      } else {
        await postreference.doc(postid).update({
          "Likes": FieldValue.arrayUnion([userid])
        });
      }
    } catch (e) {
      if (kDebugMode) print("Like Exception😕😕😕");
      if (kDebugMode) print(e.toString());
      showsnackbar(context, Colors.red, e);
    }
  }

  Future<void> addComment(
    context,
    String postid,
    String userid,
    String username,
    String commenttext,
    String userprofilepick,
  ) async {
    try {
      final String commentid = const Uuid().v1();

      final CommentsModel commentsModel = CommentsModel(
        commenttext: commenttext,
        profilepick: userprofilepick,
        username: username,
        postid: postid,
        commentid: commentid,
        datepublished: DateTime.now(),
        likesoncomment: [],
      );

      await postreference
          .doc(postid)
          .collection("Users_comments")
          .doc(commentid)
          .set(commentsModel.tojson());
    } catch (e) {
      if (kDebugMode) print("Comment Exception😕😕😕");
      if (kDebugMode) print(e.toString());
      showsnackbar(context, Colors.red, e);
    }
  }

  // **************************************************
  // *************** Like user Comments ***************
  Future<void> likeUserComments(context) async {
    try {} catch (e) {
      if (kDebugMode) print("Comment Exception😕😕😕");
      if (kDebugMode) print(e.toString());
      showsnackbar(context, Colors.red, e);
    }
  }

  // **************************************************
  // *************** Like user Comments ***************
  Future<void> deletePost(
    context,
    String postid,
    String userid,
    String uuid,
  ) async {
    try {
      await postreference.doc(postid).delete();
      FirebaseStorage.instance
          .ref()
          .child("User_Posts")
          .child(userid)
          .child(uuid)
          .delete();
    } catch (e) {
      if (kDebugMode) print("deleting post exception😕😕😕");
      if (kDebugMode) print(e.toString());
      showsnackbar(context, Colors.red, e);
    }
  }

  // **************************************************
  // ************* Searching user by name *************
  Future<QuerySnapshot> searchUserName(String name) async {
    return await userreference
        .where("Name", isGreaterThanOrEqualTo: name)
        .get();
  }

  // **************************************************
  // *************** Follow and unfollow **************
  Future<void> followUser(String uid, String followid) async {
    DocumentSnapshot ds = await userreference.doc(uid).get();
    List following = (ds.data()! as dynamic)["Following"];

    if (following.contains(following)) {
      await userreference.doc(followid).update({
        "Followers": FieldValue.arrayRemove([uid])
      });
      await userreference.doc(uid).update({
        "Following": FieldValue.arrayRemove([followid])
      });
    } else {
      await userreference.doc(followid).update({
        "Followers": FieldValue.arrayUnion([uid])
      });
      await userreference.doc(uid).update({
        "Following": FieldValue.arrayUnion([followid])
      });
    }
  }
}
