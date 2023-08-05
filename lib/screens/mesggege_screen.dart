import 'package:flutter/material.dart';
import 'package:instagram_dumy/utils/colors.dart';

class Messegescreen extends StatelessWidget {
  final String username;
  const Messegescreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(username),
        centerTitle: true,
      ),
      body: const Center(child: Text("Messages Screen")),
    );
  }
}
