import 'package:instagram_dumy/models/user_model.dart';
import 'package:instagram_dumy/providers/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_dumy/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_dumy/widgets/posts_widget.dart';
import 'package:instagram_dumy/screens/mesggege_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_dumy/screens/notifications_screen.dart';

class Feedscreen extends StatefulWidget {
  const Feedscreen({super.key});

  @override
  State<Feedscreen> createState() => _FeedsrennState();
}

class _FeedsrennState extends State<Feedscreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> postsStream;

  @override
  void initState() {
    super.initState();
    postsStream = FirebaseFirestore.instance
        .collection("Users_posts")
        .orderBy("Upload-date")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final Usermodel umodel = Provider.of<Userdataprovider>(
      context,
      listen: false,
    ).getuserdatamodel;

    return SafeArea(
      child: Scaffold(
        // Body
        body: NestedScrollView(
          floatHeaderSlivers: true,
          physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast,
          ),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              backgroundColor: mobileBackgroundColor,
              title: SvgPicture.asset(
                "assets/images/logo_name.svg",
                // ignore: deprecated_member_use
                color: primaryColor,
                height: 45.sp,
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.heart),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Messegescreen(
                        username: umodel.name,
                      ),
                    ),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.facebookMessenger),
                ),
              ],
            ),
          ],
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast,
            ),
            child: Column(
              children: [
                // Story
                storytile(),

                // Posts
                StreamBuilder(
                  stream: postsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.fast,
                        ),
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => PostsWidget(
                          snapdata: snapshot.data!.docs[index].data(),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),

                // Last Information
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox storytile() {
    return SizedBox(
      height: 12.h,
      width: double.infinity,
      child: ListView.builder(
        itemCount: 8,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.symmetric(horizontal: 6.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26.sp,
                backgroundColor: Colors.grey,
                child: Icon(
                  size: 48.sp,
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Username",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
