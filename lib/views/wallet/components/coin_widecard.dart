import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:onyxswap/custom_paints/chart_painter.dart';
import 'package:onyxswap/utils/text.dart';

class CoinWideCard extends StatelessWidget {
  const CoinWideCard(
      {Key? key, required this.coin, required this.symbol,  this.price,  required this.icon})
      : super(key: key);
  final String coin;
  final String symbol;
  final String? price;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        children: [
          Container(
            height: 74,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color(0xff353159),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xff393539).withOpacity(0.2),
                    const Color(0xff393539).withOpacity(0.3),
                    const Color(0xff393539).withOpacity(0.4),
                    const Color(0xff393539).withOpacity(0.5),
                    const Color(0xff393539).withOpacity(0.6),
                    const Color(0xff393539).withOpacity(0.6),
                    const Color(0xff393539).withOpacity(0.5),
                    const Color(0xff393539).withOpacity(0.4),
                    const Color(0xff393539).withOpacity(0.3),
                    const Color(0xff393539).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                height: 74,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        clipBehavior: Clip.hardEdge,
                        width: 44.6,
                        height: 44.6,
                        decoration: const BoxDecoration(
                          color: Color(0xff252725),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: icon,
                          // child: SvgPicture.asset(
                          //   "assets/svgs/bitcoin.svg",
                          //   height: 16,
                          //   width: 70,
                          // ),
                        ),
                      ),
                      const SizedBox(
                        width: 13.5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText.body3L(coin),
                          AppText.body3L(symbol)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: CustomPaint(
                      painter: ChartPainter(),
                    ),
                  ),
                  AppText.body2L('\$$price')
                ],
              ),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
