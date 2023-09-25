import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/virtual_cards/components/arc.dart';

class CardCard extends StatelessWidget {
  const CardCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                height: 207,
                width: 374,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: kPrimaryColor,
                ),
              ),
              const Positioned(
                bottom: 0,
                left: 0,
                // right: 0,
                // top: 0,
                child: MyArc(
                  diameter: 258,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 11),
                clipBehavior: Clip.hardEdge,
                height: 207,
                width: 374,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppText.body2L("Balance"),
                        const Spacer(),
                        AppText.body2L("NGN13450.00"),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText.heading2L("4916   9091   8053   9956"),
                        const Spacer(),
                        Image.asset("assets/pngs/chip.png")
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.body5L("Card Holder"),
                            const SizedBox(
                              height: 5,
                            ),
                            AppText.heading1L("Veni Bharwal")
                          ],
                        ),
                        const Spacer(),
                        Image.asset("assets/pngs/visa_logo.png")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        AppText.body5L("VALD THRU 23/09"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 13,
          width: (MediaQuery.of(context).size.width) / 1.22,
          decoration: const BoxDecoration(
              color: Color(0xff2B3B30),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16))),
        ),
      ],
    );
  }
}
