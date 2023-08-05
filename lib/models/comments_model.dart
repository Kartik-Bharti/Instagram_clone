class CommentsModel {
  final String commenttext;
  final String profilepick;
  final String username;
  final String postid;
  final String commentid;
  final DateTime datepublished;
  final List likesoncomment;

  CommentsModel({
    required this.commenttext,
    required this.profilepick,
    required this.username,
    required this.postid,
    required this.commentid,
    required this.datepublished,
    required this.likesoncomment,
  });

  Map<String, dynamic> tojson() => {
        "Comment": commenttext,
        "Profile-pick": profilepick,
        "Username": username,
        "Post-id": postid,
        "Comment-id": commentid,
        "Date-of-comment": datepublished,
        "Likes-on-comment": likesoncomment,
      };
}
