import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class AssetButtons extends StatelessWidget {
  const AssetButtons({Key? key, required this.title, required this.selected})
      : super(key: key);
  final String title;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      alignment: Alignment.center,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: selected ? kSuccessColor : kSecondaryColor),
          borderRadius: BorderRadius.circular(8)),
      child: AppText.body2L(title),
    );
  }
}
