import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:onyxswap/utils/text.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget(
      {Key? key, required this.image, required this.text, required this.title})
      : super(key: key);
  final String image;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Stack(children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    //shape: BoxShape.circle,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(160),
                      bottomRight: Radius.circular(160),
                    ),
                    color: Colors.white,

                    // image: DecorationImage(
                    //   image: SvgPicture.asset()
                    // ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset('assets/svgs/$image',height:MediaQuery.of(context).size.height / 3,width:double.infinity),
                    ],
                  ),
                ),
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  decoration: BoxDecoration(

                      //shape: BoxShape.circle,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(160),
                        bottomRight: Radius.circular(160),
                      ),
                      border: Border.all(width: 3, color: Colors.white)

                      // image: DecorationImage(
                      //   image: SvgPicture.asset()
                      // ),
                      ),
                ),
                // Positioned(
                //     bottom: 0,
                //     // height: MediaQuery.of(context).size.height / 3,
                //     width: MediaQuery.of(context).size.height / 2.5,
                //     child: SvgPicture.asset('assets/svgs/$image'),
                //     ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  AppText.heading3N(title, centered: true, color: Colors.white),
                  const SizedBox(
                    height: 17,
                  ),
                  AppText.caption2N(
                    text,
                    centered: true,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
