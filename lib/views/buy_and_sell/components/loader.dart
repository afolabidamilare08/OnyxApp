import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:onyxswap/utils/color.dart';

class PinLoader extends StatelessWidget {
  const PinLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(15),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Lottie.asset("assets/lotties/loader.json",
                  height: 20, width: 20)),
        ),
      ),
    );
  }
}
