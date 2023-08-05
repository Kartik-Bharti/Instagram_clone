import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[700]!.withOpacity(.9),
            highlightColor: Colors.grey[400]!,
            child: CircleAvatar(radius: 30.sp),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[700]!.withOpacity(.9),
                highlightColor: Colors.grey[400]!,
                child: Container(
                  height: 15.5.sp,
                  width: 188.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 7.5.sp),
              Shimmer.fromColors(
                baseColor: Colors.grey[700]!.withOpacity(.9),
                highlightColor: Colors.grey[400]!,
                child: Container(
                  width: 150.sp,
                  height: 15.5.sp,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
