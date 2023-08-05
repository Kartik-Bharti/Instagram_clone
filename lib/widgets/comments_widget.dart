import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CommentsWidget extends StatelessWidget {
  final Map<String, dynamic> snapdata;
  const CommentsWidget({super.key, required this.snapdata});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          snapdata["Profile-pick"] == ""
              ? CircleAvatar(
                  radius: 17.sp,
                  child: Image.asset("assets/images/profile.png"),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: NetworkImage(snapdata["Profile-pick"]),
                    height: 42,
                  ),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: ("${snapdata["Username"]}: "),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: (snapdata["Comment"]),
                          style: const TextStyle(fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMEd()
                          .add_jm()
                          .format(snapdata["Date-of-comment"].toDate()),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 9.5, right: 6),
            child: Icon(Icons.favorite, size: 20),
          )
        ],
      ),
    );
  }
}
