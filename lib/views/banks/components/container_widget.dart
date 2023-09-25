import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget(
      {Key? key,
      required this.bank,
      required this.accountNumber,
      required this.accountname})
      : super(key: key);
  final String bank;
  final String accountNumber;
  final String accountname;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      width: double.infinity,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: kBorderColor),
              top: BorderSide(color: kBorderColor))),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xff373837)),
                child: SvgPicture.asset(
                  'assets/pngs/bankSvg.svg',
                  width: 15,
                  height: 15,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 1.5) - 16,
                    child: AppText.button2L(
                      bank,
                      multitext: true,
                    ),
                  ),
                  AppText.body2L(
                    accountname,
                    color: kSecondaryColor,
                  ),
                  AppText.body2L(accountNumber),
                ],
              ),
              //Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    NyxIcons.next,
                    color: kSecondaryColor,
                    size: 15,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
