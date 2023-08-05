import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_dumy/utils/colors.dart';
import 'package:instagram_dumy/widgets/shrimmer.dart';
import 'package:instagram_dumy/models/user_model.dart';
import 'package:instagram_dumy/screens/feed_screen.dart';
import 'package:instagram_dumy/screens/search_screen.dart';
import 'package:instagram_dumy/screens/account_screen.dart';
import 'package:instagram_dumy/screens/add_post_screen.dart';
import 'package:instagram_dumy/providers/user_data_provider.dart';

class MainUserScreen extends StatefulWidget {
  const MainUserScreen({super.key});

  @override
  State<MainUserScreen> createState() => _MainUserScreenState();
}

class _MainUserScreenState extends State<MainUserScreen> {
  int page = 0;
  late PageController pageController;
  late Future<Usermodel?> finalusermodel;
  String useraccountimage =
      "https://t3.ftcdn.net/jpg/00/64/67/80/360_F_64678017_zUpiZFjj04cnLri7oADnyMH0XBYyQghG.jpg";

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    finalusermodel = usermodelcalled();
  }

  Future<Usermodel> usermodelcalled() async {
    Usermodel usermodel = await Provider.of<Userdataprovider>(
      context,
      listen: false,
    ).refreshuserdata();

    if (kDebugMode) print("Sucessfully called usermodel");
    if (kDebugMode) print(usermodel.tojson());

    return usermodel;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: finalusermodel,
      builder: (context, snapshot) {
        if (kDebugMode) print("Snapshot data🤩:- ${snapshot.data}");
        return snapshot.hasData
            ? Consumer<Userdataprovider>(
                builder: (context, value, child) {
                  return Scaffold(
                    body: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Feed Screen
                        const Feedscreen(),

                        // Search Screen
                        const SearchScreen(),

                        // Add Post Screen
                        Addpostscreen(usermodel: value.getuserdatamodel),

                        // Reels Screen
                        const Center(child: Text("Reels screen")),

                        // Account setting Screen
                        AccountScreen(userid: value.getuserdatamodel.uid),
                      ],
                    ),

                    // BottomNavbar
                    bottomNavigationBar: BottomNavigationBar(
                      backgroundColor: mobileBackgroundColor,
                      type: BottomNavigationBarType.fixed,
                      selectedItemColor: primaryColor,
                      currentIndex: page,
                      iconSize: 25.sp,
                      onTap: (value) {
                        navigatetopage(value);
                        setState(() => page = value);
                      },
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(
                            page == 0 ? Icons.home_sharp : Icons.home_outlined,
                            color: Colors.white,
                          ),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            page == 1
                                ? Icons.search_sharp
                                : Icons.search_rounded,
                            color: Colors.white,
                          ),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            page == 2
                                ? Icons.add_box_rounded
                                : Icons.add_box_outlined,
                            color: Colors.white,
                          ),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          icon: Image.asset(
                            "assets/images/reels_icon.png",
                            color: Colors.white,
                          ),
                          label: "",
                        ),
                        BottomNavigationBarItem(
                          icon: CircleAvatar(
                            radius: 12.sp,
                            backgroundImage: NetworkImage(
                              value.getuserdatamodel.profilepick != ""
                                  ? value.getuserdatamodel.profilepick
                                  : useraccountimage,
                            ),
                          ),
                          label: "",
                        ),
                      ],
                    ),
                  );
                },
              )
            : ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: const ShimmerEffect(),
                ),
              );
      },
    );
  }

  void navigatetopage(int changedpage) {
    pageController.jumpToPage(changedpage);
  }
}
