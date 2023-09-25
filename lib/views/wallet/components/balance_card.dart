import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/utils/color.dart';

import 'package:onyxswap/utils/text.dart';

class BalanceCard extends StatelessWidget {
  BalanceCard({Key? key, required this.balance, required this.cancel})
      : super(key: key);
  final NavigationService _navigationService = NavigationService.I;
  final String balance;
  final Function() cancel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17)),
              ),
              height: 128,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xffBA55D6).withOpacity(0.25),
                              spreadRadius: 40,
                              blurRadius: 40)
                        ],
                        color: const Color(0xffBA55D6),
                      ),
                      height: 92,
                      width: 122),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff4A37E1).withOpacity(0.25),
                          spreadRadius: 40,
                          blurRadius: 40,
                        )
                      ],
                      color: const Color(0xff4A37E1),
                    ),
                    height: 85,
                    width: MediaQuery.of(context).size.width / 3 - 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffFFE8BA).withOpacity(0.25),
                          spreadRadius: 40,
                          blurRadius: 60,
                        )
                      ],
                      // borderRadius: BorderRadius.only(
                      //     topLeft: Radius.circular(17)),
                      color: const Color(0xffFFE8BA),
                    ),
                    height: 65,
                    width: MediaQuery.of(context).size.width / 3 - 20,
                  ),
                ],
              ),
            ),
            ClipRRect(
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14))),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    height: 128,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.body1L(
                        "Naira Balance",
                        color: const Color(0xffa7a7a7),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      AppText.body1PSB(
                        "NGN$balance",
                        color: kSecondaryColor,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 34.16,
                    width: 71.45,
                    decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.36),
                        borderRadius: BorderRadius.circular(26)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.arrowtriangle_up_fill,
                          color: Color(0xff2B3B30),
                          size: 20,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        AppText.button3P(
                          "15%",
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(17),
              bottomRight: Radius.circular(17),
            ),
          ),
          height: 79.27,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...List.generate(
                4,
                (index) => InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    cancel;
                    _navigationService.navigateTo(index == 0
                        ? NavigatorRoutes.buy
                        : index == 1
                            ? NavigatorRoutes.recieve
                            : index == 2
                                ? NavigatorRoutes.sell
                                : NavigatorRoutes.send);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        index == 0
                            ? Icons.add_circle_outline
                            : index == 1
                                ? Icons.system_update_alt
                                : index == 2
                                    ? NyxIcons.send
                                    : CupertinoIcons.upload_circle,
                        color: kSecondaryColor,
                        size: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppText.body3L(index == 0
                          ? "Buy"
                          : index == 1
                              ? "Recieve"
                              : index == 2
                                  ? "Sell"
                                  : "Send")
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
