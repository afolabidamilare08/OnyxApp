import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:onyxswap/utils/text.dart';

class CoinSquareCard extends StatelessWidget {
  const CoinSquareCard(
      {Key? key,
      required this.icon,
      required this.title,
      required this.sign,
      required this.price,
      required this.balance})
      : super(key: key);
  final Widget icon;
  final String title;
  final String sign;
  final String price;
  final String balance;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 121,
                //maxWidth: 115,
              ),
              height: MediaQuery.of(context).size.width / 3.2,
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xff353159).withOpacity(0.5), width: 2),
                color:
                    // Colors.white,
                    const Color(0xff393539),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 2,
                    center: Alignment.center,
                    colors: [
                      const Color(0xff353159).withOpacity(0.1),
                      const Color(0xff353159).withOpacity(0.2),
                      const Color(0xff353159).withOpacity(0.3),
                      const Color(0xff353159).withOpacity(0.7),
                      const Color(0xff353159).withOpacity(0.55),
                      const Color(0xff353159).withOpacity(0.6),
                      const Color(0xff353159).withOpacity(0.65),
                      const Color(0xff353159).withOpacity(0.7),
                      const Color(0xff353159).withOpacity(0.75),
                      const Color(0xff353159).withOpacity(0.8),
                      const Color(0xff353159).withOpacity(0.85),
                      const Color(0xff353159).withOpacity(0.9)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          clipBehavior: Clip.hardEdge,
                          width: 44.6,
                          height: 44.6,
                          decoration: const BoxDecoration(
                            color: Color(0xff353935),
                            gradient: RadialGradient(
                              radius: 2,
                              center: Alignment.center,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Color(0xff353935),
                                Color(0xff353935),
                                Color(0xff353935),
                                Color(0xff353935),
                                Color(0xff353935),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Center(child: icon),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4.5,
                    ),
                    AppText.body5L(title),
                    const SizedBox(
                      height: 4,
                    ),
                    AppText.body6L('$price $sign'),
                    const SizedBox(
                      height: 5.5,
                    ),
                    Container(
                      // width: 43.71,
                      height: 16.95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.2),
                        color: const Color(0xff353935),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SvgPicture.asset(
                            //   "assets/svgs/pin.svg",
                            // ),
                            // const SizedBox(
                            //   width: 5.5,
                            // ),
                            AppText.body6L(
                               balance
                                ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
