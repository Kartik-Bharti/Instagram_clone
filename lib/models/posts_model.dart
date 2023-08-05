class Postmodel {
  final String username;
  final String description;
  final String uploadedpost;
  final String profilepick;
  final DateTime date;
  final String uid;
  final String uuid;
  final String postId;
  final List likes;

  Postmodel({
    required this.username,
    required this.description,
    required this.uploadedpost,
    required this.profilepick,
    required this.date,
    required this.uid,
    required this.uuid,
    required this.postId,
    required this.likes,
  });

  Map<String, dynamic> tojson() => {
        "Name": username,
        "Post-description": description,
        "Uploaded-pick": uploadedpost,
        "Profile-pick": profilepick,
        "Upload-date": date,
        "User-Id": uid,
        "Post-Id": postId,
        "Likes": likes,
        "UUId": uuid,
      };

//   factory Postmodel.datasnapshot(DocumentSnapshot sp) {
//     final Map<String, dynamic> snap = sp.data() as Map<String, dynamic>;

//     return Postmodel(
//       username: snap["Name"],
//       description: snap["Description"],
//       uploadedpost: snap["Uploaded-Post"],
//       profilepick: snap["Profile-pick"],
//       date: snap["Upload-date"],
//       uid: snap["User-Id"],
//       postId: snap["Post-Id"],
//       likes: snap["Likes"],
//     );
//   }
}
