// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class BillCard extends StatelessWidget {
  BillCard({Key? key, required this.index}) : super(key: key);
  final int index;
  final NavigationService _navigationService = NavigationService.I;
  List<String> billName = [
    "Electricity",
    "Cable",
    "Airtime & Data",
    
  ];
  List<IconData> billIcon = [
    NyxIcons.electricity,
    NyxIcons.paybills,
    NyxIcons.airtime,
    
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        index == 0
            ? _navigationService.navigateTo(NavigatorRoutes.payBills)
            : index == 2
                ? _navigationService.navigateTo(NavigatorRoutes.buyAirtime)
                : _navigationService.navigateTo(NavigatorRoutes.cable);
      },
      child: Column(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: const Color(0xff393539),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 102,
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    padding: const EdgeInsets.only(left: 8, top: 23),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(colors: [
                        const Color(0xff353935),
                        const Color(0xff353935).withOpacity(0.9),
                        const Color(0xff353935).withOpacity(0.7),
                        const Color(0xff353935).withOpacity(0.6),
                        const Color(0xff353935).withOpacity(0.4),
                        const Color(0xff353935).withOpacity(0.5),
                        const Color(0xff353935).withOpacity(0.4),
                        const Color(0xff353935).withOpacity(0.3),
                        const Color(0xff353935).withOpacity(0.2),
                        const Color(0xff393539).withOpacity(0.1),
                        const Color(0xff393539).withOpacity(0.7),
                        const Color(0xff393539).withOpacity(0.4),
                      ]),
                    ),
                    // width: 180,
                    height: 102,
                  ),
                  index == 0
                      ? Positioned(
                          bottom: -10,
                          right: -8,
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/ellipse1.svg"),
                            ],
                          ),
                          height: 102,
                        )
                      : const SizedBox.shrink(),
                  index == 0
                      ? Positioned(
                          bottom: 0,
                          right: -5,
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/ellipse2.svg"),
                            ],
                          ),
                          height: 102,
                        )
                      : const SizedBox.shrink(),
                  index == 0
                      ? Positioned(
                          top: 0,
                          right: -5,
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/ellipse3.svg"),
                            ],
                          ),
                          height: 102,
                        )
                      : const SizedBox.shrink(),
                  index == 1
                      ? Positioned(
                          top: -2,
                          right: 0,
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/card2ell1.svg"),
                            ],
                          ),
                          height: 102,
                        )
                      : const SizedBox.shrink(),
                  index == 1
                      ? Positioned(
                          top: -2,
                          right: 7,
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/card2ell2.svg"),
                            ],
                          ),
                          height: 102,
                        )
                      : const SizedBox.shrink(),
                  index == 1
                      ? Positioned(
                          top: -2,
                          right: 20,
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/card2ell3.svg"),
                            ],
                          ),
                          height: 102,
                        )
                      : const SizedBox.shrink(),
                  index == 2
                      ? Positioned(
                          top: -18,
                          left: 0,
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/card4ell1.svg"),
                            ],
                          ),
                          height: 102,
                        )
                      : const SizedBox.shrink(),
                  index == 2
                      ? Positioned(
                          top: -22,
                          left: 0,
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/card4ell2.svg"),
                            ],
                          ),
                          height: 102,
                        )
                      : const SizedBox.shrink(),
                  index == 2
                      ? Positioned(
                          top: -25,
                          left: 0,
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/svgs/card4ell3.svg"),
                            ],
                          ),
                          height: 102,
                        )
                      : const SizedBox.shrink(),
                  Positioned(
                    width: 200,
                    top: 20,
                    left: -50,
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                            child: Icon(
                              billIcon[index],
                              color: kSecondaryColor,
                            ),
                          ),
                          height: 38,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 1, color: kSecondaryColor),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        AppText.body5L(
                          billName[index],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
