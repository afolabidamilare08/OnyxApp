import 'dart:ui';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/utils/app_colors.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/custom_icons.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/Security/component/setup_pin.dart';
import 'package:onyxswap/views/virtual_cards/components/card_card.dart';
import 'package:onyxswap/views/virtual_cards/components/card_options.dart';
import 'package:onyxswap/views/virtual_cards/components/transactions_card.dart';

import '../../core/constants/custom_icons.dart';

class VirtualCardView extends StatefulWidget {
  const VirtualCardView({Key? key}) : super(key: key);

  @override
  State<VirtualCardView> createState() => _VirtualCardViewState();
}

List<IconData> icons = [
  Icons.visibility_outlined,
  NyxIcons.funds,
  NyxIcons.block,
];
List<String> title = ['View card', 'Change pin', 'Block card'];

class _VirtualCardViewState extends State<VirtualCardView> {
  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: AppColors.backgroundColor,
      child: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 28,
                    ),
                    AppText.heading1L("My Cards"),
                    const SizedBox(
                      height: 35,
                    ),
                    const CardCard(),
                    const SizedBox(
                      height: 37,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...List.generate(
                            3,
                            (index) => CardOptions(
                                icon: icons[index],
                                title: title[index],
                                onTap: index == 1
                                    ? () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PinSetup(
                                                heading: 'Change Pin',
                                                title: 'Old Pin',
                                                subtitle: 'New Pin'),
                                          ),
                                        )
                                    : () {}))
                      ],
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: AppText.heading1L("Transactions"),
                    ),
                    ...List.generate(2, (index) => const TransactionsCard())
                  ],
                ),
              )
            ],
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
              child: Center(
                  child: AppText.heading1N(
                'COMING SOON',
                color: kSecondaryColor,
              )),
            ),
          )
        ],
      ),
    );
  }
}
