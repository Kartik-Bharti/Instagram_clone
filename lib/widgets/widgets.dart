import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void nextpage(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void nextpagereplacement(context, page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );
}

void showsnackbar(context, color, e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(e.toString()),
      duration: const Duration(seconds: 5),
      backgroundColor: color,
    ),
  );
}

void activityloaderdialouge(context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          SizedBox(width: 15.sp),
          const Text("Loading..."),
        ],
      ),
    ),
  );
}
