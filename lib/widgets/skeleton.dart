import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton(
      {this.height, this.width, this.isRounded = true, Key? key, this.radius})
      : super(key: key);
  final double? height, width, radius;
  final bool isRounded;
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(colors: [
        Colors.black,
        Colors.grey.shade700,
      ]),
      // loop: 30,
      period: const Duration(milliseconds: 2000),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            radius != null
                ? radius!
                : isRounded
                    ? 20
                    : 0,
          ),
          color: kSkelenton,
        ),
        padding: const EdgeInsets.all(5),
      ),
    );
  }
}
