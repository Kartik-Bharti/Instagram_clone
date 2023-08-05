import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_dumy/utils/colors.dart';
import 'package:instagram_dumy/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_dumy/models/user_model.dart';
import 'package:instagram_dumy/animations/like_animation.dart';
import 'package:instagram_dumy/screens/comments_screen.dart';
import 'package:instagram_dumy/services/database_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_dumy/providers/user_data_provider.dart';

class PostsWidget extends StatefulWidget {
  final Map<String, dynamic> snapdata;
  const PostsWidget({super.key, required this.snapdata});

  @override
  State<PostsWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostsWidget> {
  ValueNotifier<bool> isLikeAnimating = ValueNotifier<bool>(false);
  int totlacomments = 0;

  @override
  void initState() {
    super.initState();
    getTotalComments();
  }

  void getTotalComments() async {
    try {
      QuerySnapshot dc = await FirebaseFirestore.instance
          .collection("Users_posts")
          .doc(widget.snapdata["Post-Id"])
          .collection("Users_comments")
          .get();

      totlacomments = dc.docs.length;

      setState(() {});
    } catch (e) {
      if (kDebugMode) print("Getting total comments exception😕😕😕");
      if (kDebugMode) print(e.toString());
      if (mounted) showsnackbar(context, Colors.red, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Usermodel umodel = Provider.of<Userdataprovider>(context).getuserdatamodel;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 20.sp),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 2.sp),
            child: Row(
              children: [
                widget.snapdata["Profile-pick"] != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15.sp),
                        child: Image(
                          height: 28.sp,
                          image: NetworkImage(widget.snapdata["Profile-pick"]),
                        ),
                      )
                    : CircleAvatar(
                        radius: 15.sp,
                        child: Image.asset("assets/images/profile.png"),
                      ),
                const Expanded(child: SizedBox()),
                Text(
                  widget.snapdata["Name"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              umodel.uid == widget.snapdata["User-Id"]
                                  ? "Delete"
                                  : "Repost",
                              "Hide Post",
                              "Share"
                            ]
                                .map(
                                  (e) => InkWell(
                                    onTap: () {
                                      if (e == "Delete" &&
                                          umodel.uid ==
                                              widget.snapdata["User-Id"]) {
                                        Databaseservice().deletePost(
                                          context,
                                          widget.snapdata["Post-Id"],
                                          widget.snapdata["User-Id"],
                                          widget.snapdata["UUId"],
                                        );
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15.sp,
                                        horizontal: 18.sp,
                                      ),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),

          // Image
          ValueListenableBuilder(
            valueListenable: isLikeAnimating,
            builder: (context, value, child) {
              return GestureDetector(
                onDoubleTap: () async {
                  await Databaseservice().likePost(
                    widget.snapdata["Post-Id"],
                    umodel.uid,
                    widget.snapdata["Likes"],
                    context,
                  );
                  isLikeAnimating.value = true;
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1 / 1.2,
                      child: Image(
                        image: NetworkImage(widget.snapdata["Uploaded-pick"]),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: isLikeAnimating.value ? 1 : 0,
                      child: LikeAnimation(
                        isanimating: isLikeAnimating.value,
                        duration: const Duration(milliseconds: 100),
                        onend: () => isLikeAnimating.value = false,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 150,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),

          // Other Icons
          Row(
            children: [
              LikeAnimation(
                // isanimating: widget.snapdata["Likes"].contains(umodel.uid),
                isanimating: false,
                smallike: true,
                child: IconButton(
                  onPressed: () async => await Databaseservice().likePost(
                    widget.snapdata["Post-Id"],
                    umodel.uid,
                    widget.snapdata["Likes"],
                    context,
                  ),
                  icon: widget.snapdata["Likes"].contains(umodel.uid)
                      ? const Icon(Icons.favorite, color: Colors.red, size: 30)
                      : const FaIcon(FontAwesomeIcons.heart),
                ),
              ),
              IconButton(
                onPressed: () => nextpage(
                  context,
                  CommentsScreen(snapdata: widget.snapdata),
                ),
                icon: const FaIcon(FontAwesomeIcons.comment),
              ),
              IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.paperPlane),
              ),
              const Expanded(child: SizedBox()),
              IconButton(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.bookmark),
              ),
            ],
          ),

          // Comments
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: widget.snapdata["Likes"].length == 1
                      ? Text(
                          "${widget.snapdata["Likes"].length} Like",
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      : Text(
                          "${widget.snapdata["Likes"].length} Likes",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 2),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "@${widget.snapdata["Name"]} ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: widget.snapdata["Post-description"],
                          style: const TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    nextpage(
                      context,
                      CommentsScreen(snapdata: widget.snapdata),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.5),
                    child: totlacomments == 0
                        ? const Text(
                            "No comment yet, tap to write first comment",
                            style: TextStyle(
                              fontSize: 11,
                              color: secondaryColor,
                            ),
                          )
                        : Text(
                            "Tap to view all $totlacomments comments",
                            style: const TextStyle(
                              fontSize: 11,
                              color: secondaryColor,
                            ),
                          ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.5),
                    child: Text(
                      DateFormat.yMMMEd().format(
                        widget.snapdata["Upload-date"].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 11,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
