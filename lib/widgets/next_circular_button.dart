import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';

class NextCircularButton extends StatelessWidget {
  const NextCircularButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: kPrimaryColor.withOpacity(0.7),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(6.1, 6.1)),
        ],
        shape: BoxShape.circle,
        color: kPrimaryColor,
      ),
      height: 45,
      width: 45,
      child: const Icon(
        CupertinoIcons.arrow_right,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
