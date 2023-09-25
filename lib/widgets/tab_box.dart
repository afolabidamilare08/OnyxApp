import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class TabBox extends StatelessWidget {
  const TabBox({ Key? key,  this.height, required this.text ,required this.color, this.left, this.right}) : super(key: key);
final double? height;
final double? left;
final double? right;
final String text;
final Color color;
  @override
  Widget build(BuildContext context) {
    return  Container(
                  height: height,
                  decoration: BoxDecoration(color: color,borderRadius: BorderRadius.only(topLeft: Radius.circular(left??0.0),topRight: Radius.circular(right??0.0))),
                  width: MediaQuery.of(context).size.width/2,
                  child: Center(
                    child: AppText.heading3N(text,color: kSecondaryColor,),
                  ),
                );
  }
}