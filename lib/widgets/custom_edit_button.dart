import 'package:flutter/material.dart';

class CustomEditButton extends StatelessWidget {
  final Function() responcefunction;
  final Color backgroundcolor;
  final String label;
  const CustomEditButton({
    super.key,
    required this.backgroundcolor,
    required this.responcefunction,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: responcefunction,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.symmetric(vertical: 8.5, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundcolor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
