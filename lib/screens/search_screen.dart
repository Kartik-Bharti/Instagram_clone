import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:instagram_dumy/utils/colors.dart';
import 'package:instagram_dumy/widgets/widgets.dart';
import 'package:instagram_dumy/widgets/shrimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_dumy/screens/account_screen.dart';
import 'package:instagram_dumy/services/database_services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchcontroller = TextEditingController();
  String? searchedname;
  bool issearched = false;

  @override
  void dispose() {
    super.dispose();
    searchcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: searchcontroller,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.white),
              border: InputBorder.none,
              hintText: "Search for user",
              hintStyle: TextStyle(color: Colors.white),
            ),
            onSubmitted: (value) {
              setState(() {
                searchedname = value.toString().trim();
                if (value.toString().trim() != "") {
                  issearched = true;
                }
              });
            },
          ),
        ),
      ),

      // Body
      body: issearched
          ? FutureBuilder(
              future: Databaseservice().searchUserName(searchedname!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 8,
                    itemBuilder: (context, index) => const ShimmerEffect(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    height: 150,
                    child: const Text(
                      "No user found with this username",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        nextpage(
                          context,
                          AccountScreen(
                            userid: snapshot.data!.docs[index]["User-Id"],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: snapshot.data!.docs[index]["Profile-pic"] !=
                                  ""
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: Image(
                                    image: NetworkImage(
                                      snapshot.data!.docs[index]["Profile-pic"],
                                    ),
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                          title: Text(snapshot.data!.docs[index]["Name"]),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future:
                  FirebaseFirestore.instance.collection("Users_posts").get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Row(
                    children: [
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[700]!.withOpacity(.9),
                          highlightColor: Colors.grey[200]!,
                          child: const SizedBox(height: 320, width: 200),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[700]!.withOpacity(.9),
                              highlightColor: Colors.grey[200]!,
                              child: const SizedBox(height: 160, width: 200),
                            ),
                            const SizedBox(height: 7.5),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[700]!.withOpacity(.9),
                              highlightColor: Colors.grey[200]!,
                              child: const SizedBox(height: 160, width: 200),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
                return AlignedGridView.count(
                  crossAxisCount: 3,
                  physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.normal,
                  ),
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => Image.network(
                    snapshot.data!.docs[index]["Uploaded-pick"],
                  ),
                );
              },
            ),
    );
  }
}
