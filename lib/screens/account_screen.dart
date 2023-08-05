import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_dumy/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_dumy/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_dumy/screens/login_screen.dart';
import 'package:instagram_dumy/services/auth_services.dart';
import 'package:instagram_dumy/widgets/custom_edit_button.dart';
import 'package:instagram_dumy/services/database_services.dart';
import 'package:instagram_dumy/services/shared_preference.dart';

class AccountScreen extends StatefulWidget {
  final String userid;
  const AccountScreen({super.key, required this.userid});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Map userdata = {};
  int postlength = 0;
  bool isloading = true;
  bool isfollowing = false;
  String currentuserid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getuserData(context);
  }

  void getuserData(context) async {
    try {
      setState(() => isloading = true);

      var userdatasnap = await FirebaseFirestore.instance
          .collection("Users_data")
          .doc(widget.userid)
          .get();
      // .timeout(const Duration(milliseconds: 1500));

      var totalpostsbyuser = await FirebaseFirestore.instance
          .collection("Users_posts")
          .where("User-Id", isEqualTo: widget.userid)
          .get();

      postlength = totalpostsbyuser.docs.length;
      userdata = userdatasnap.data()!;
      isfollowing =
          await userdatasnap.data()!["Followers"].contains(currentuserid);

      if (mounted) setState(() => isloading = false);
    } catch (e) {
      if (kDebugMode) print("Getting profile data xception😕😕😕");
      if (kDebugMode) print(e.toString());
      showsnackbar(context, Colors.red, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isloading
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              // Apppbar
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                title: Text(userdata["Name"]),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.sp),
                    child: InkWell(
                      onTap: () => logout(context),
                      child: const Icon(Icons.vertical_split),
                    ),
                  )
                ],
              ),

              // Body
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.normal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                            radius: 42.sp,
                            backgroundColor: Colors.grey.shade800,
                            child: userdata["Profile-pic"] != ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(40.sp),
                                    child: Image(
                                      image: NetworkImage(
                                        userdata["Profile-pic"],
                                      ),
                                    ),
                                  )
                                : Image.asset("assets/images/profile.png"),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                userDataField(postlength, "Posts"),
                                userDataField(
                                  userdata["Followers"].length,
                                  "Followers",
                                ),
                                userDataField(
                                  userdata["Following"].length,
                                  "Following",
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 2),

                    // User data
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 2.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userdata["Name"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(userdata["Email"]),
                          userdata["Bio"] != ""
                              ? Text(userdata["Bio"])
                              : const Text("No Bio yet"),
                        ],
                      ),
                    ),

                    // Edit profile and follow button
                    currentuserid == widget.userid
                        ? CustomEditButton(
                            responcefunction: () {},
                            backgroundcolor: Colors.grey.shade800,
                            label: "Edit profile",
                          )
                        : isfollowing
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: CustomEditButton(
                                      responcefunction: () async {
                                        await Databaseservice().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userdata["User-Id"],
                                        );
                                        setState(() {
                                          isfollowing = false;
                                          userdata["Followers"].length--;
                                        });
                                      },
                                      backgroundcolor: Colors.grey.shade800,
                                      label: "Unfollow",
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomEditButton(
                                      responcefunction: () {},
                                      backgroundcolor: Colors.blue,
                                      label: "Message",
                                    ),
                                  ),
                                ],
                              )
                            : CustomEditButton(
                                responcefunction: () async {
                                  await Databaseservice().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    userdata["User-Id"],
                                  );
                                  setState(() {
                                    isfollowing = true;
                                    userdata["Followers"].length++;
                                  });
                                },
                                backgroundcolor: Colors.blue,
                                label: "Follow",
                              ),
                    const Divider(thickness: 0),

                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection("Users_posts")
                          .where("User-Id", isEqualTo: widget.userid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade700,
                            highlightColor: Colors.grey.shade500,
                            child: const SizedBox(height: 160, width: 160),
                          );
                        }
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 2,
                            childAspectRatio: 1,
                          ),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.fast,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              child: Image(
                                image: NetworkImage(
                                  snapshot.data!.docs[index]["Uploaded-pick"],
                                ),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void logout(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure, you want to logout!"),
        actions: [
          InkWell(
            onTap: () async {
              activityloaderdialouge(context);
              // Loging out
              final Authservices authservices = Authservices();
              await authservices.signout(context).whenComplete(() {
                nextpagereplacement(context, const Loginscreen());
              });
              await Sharedprefference.saveuselogein(false);
            },
            child: const Text("Yes"),
          ),
          SizedBox(width: 10.sp),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          SizedBox(width: 10.sp),
        ],
      ),
    );
  }

  Column userDataField(int num, String s) {
    return Column(
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          s,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade300,
            fontWeight: FontWeight.normal,
          ),
        )
      ],
    );
  }
}
