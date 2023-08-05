import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instagram_dumy/utils/colors.dart';
import 'package:instagram_dumy/models/user_model.dart';
import 'package:instagram_dumy/widgets/comments_widget.dart';
import 'package:instagram_dumy/services/database_services.dart';
import 'package:instagram_dumy/providers/user_data_provider.dart';

class CommentsScreen extends StatefulWidget {
  final Map<String, dynamic> snapdata;
  const CommentsScreen({super.key, required this.snapdata});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Usermodel umodel = Provider.of<Userdataprovider>(context).getuserdatamodel;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // AppBar
        appBar: AppBar(
          title: const Text("Comments"),
          centerTitle: true,
          backgroundColor: mobileBackgroundColor,
        ),

        // Body
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("Users_posts")
              .doc(widget.snapdata["Post-Id"])
              .collection("Users_comments")
              .orderBy("Date-of-comment")
              .get(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return CommentsWidget(
                        snapdata: snapshot.data!.docs[index].data(),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator());
          },
        ),

        // BottomNavigation Bar
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: const EdgeInsets.only(left: 15, bottom: 8, right: 15),
            child: Row(
              children: [
                umodel.profilepick != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: NetworkImage(umodel.profilepick),
                          height: 40,
                        ),
                      )
                    : CircleAvatar(
                        radius: 15.sp,
                        child: Image.asset("assets/images/profile.png"),
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: commentcontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Comment as @${umodel.name}",
                        hintStyle: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (commentcontroller.text.toString().trim().isNotEmpty) {
                      await Databaseservice().addComment(
                        context,
                        widget.snapdata["Post-Id"],
                        umodel.uid,
                        umodel.name,
                        commentcontroller.text.toString().trim(),
                        umodel.profilepick,
                      );
                      setState(() => commentcontroller.clear());
                    }
                  },
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
