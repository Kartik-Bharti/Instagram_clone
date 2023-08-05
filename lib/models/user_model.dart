import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {
  final String name;
  final String email;
  final String profilepick;
  final String uid;
  final String bio;
  final List followers;
  final List following;

  Usermodel({
    required this.name,
    required this.email,
    required this.profilepick,
    required this.uid,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> tojson() => {
        "Name": name,
        "Email": email,
        "Profile-pic": profilepick,
        "User-Id": uid,
        "Bio": "",
        "Followers": [],
        "Following": [],
      };

  factory Usermodel.datasnapshot(DocumentSnapshot sp) {
    final Map<String, dynamic> snap = sp.data() as Map<String, dynamic>;
    return Usermodel(
      name: snap["Name"],
      email: snap["Email"],
      profilepick: snap["Profile-pic"],
      uid: snap["User-Id"],
      bio: snap["Bio"],
      followers: snap["Followers"],
      following: snap["Following"],
    );
  }
}
