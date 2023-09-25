import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget(
      {Key? key,
      required this.asset,
      required this.status,
      required this.date,
      required this.amount,
      this.fromWho,
      this.charges,
      this.eToken,
      required this.type})
      : super(key: key);
  final String asset;
  final String status;
  final String date;
  final String amount;
  final String? type;
  final String? fromWho;
  final String? eToken;
  final String? charges;

  @override
  Widget build(BuildContext context) {
    String modifieddate = date.split('').getRange(0, date.length - 2).join();
    String finalAmount = double.tryParse(amount)!.toStringAsFixed(7);
    return asset == 'NAIRA' && type == 'SEND' ||
            type == 'RECIEVED' ||
            type == null
        ? SizedBox()
        : Column(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height / 9,
                width: double.infinity,
                decoration: const BoxDecoration(border: Border.symmetric()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            MediaQuery.of(context).size.width <= 400
                                ? Container(
                                    height: 30,
                                    width: 30,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kBorderColor),
                                    child: asset == 'BTC'
                                        ? SvgPicture.asset(
                                            'assets/svgs/bitcoin.svg',
                                            height: 15,
                                            width: 15,
                                          )
                                        : asset == 'NAIRA'
                                            ? SvgPicture.asset(
                                                'assets/svgs/naira.svg',
                                                height: 15,
                                                width: 15,
                                              )
                                            : asset == 'USDT'
                                                ? const Icon(
                                                    NyxIcons.usdt,
                                                    color: Color(0xff12EFEF),
                                                  )
                                                : const Icon(
                                                    NyxIcons.busd,
                                                    color: Color(0xff12EFEF),
                                                  ))
                                : Container(
                                    height: 45,
                                    width: 45,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kBorderColor),
                                    child: asset == 'BTC'
                                        ? SvgPicture.asset(
                                            'assets/svgs/bitcoin.svg',
                                            height: 20,
                                            width: 20,
                                          )
                                        : asset == 'NAIRA'
                                            ? SvgPicture.asset(
                                                'assets/svgs/naira.svg',
                                                height: 20,
                                                width: 20,
                                              )
                                            : const Icon(
                                                NyxIcons.usdt,
                                                color: Color(0xff12EFEF),
                                              )),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MediaQuery.of(context).size.width <= 400
                                    ? AppText.body5L(
                                        asset == 'NAIRA'
                                            ? type!
                                            : '$asset $type',
                                        color: kSecondaryColor,
                                      )
                                    : AppText.body4L(
                                        asset == 'NAIRA'
                                            ? type!
                                            : '$asset $type',
                                        color: kSecondaryColor,
                                      ),
                                AppText.body5L(
                                  date,
                                  color: kSecondaryColor,
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width <= 400
                              ? (MediaQuery.of(context).size.width) / 3.5
                              : (MediaQuery.of(context).size.width) / 2.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AppText.body4L(
                                asset == 'NAIRA'
                                    ? ' NGN$amount'
                                    : finalAmount + asset,
                                color: kSecondaryColor,
                                multitext: true,
                              ),
                              AppText.body4L(
                                status,
                                multitext: true,
                                color: status == 'SUCCESS' ||
                                        status == 'COMPLETED'
                                    ? const Color(0xff30A008).withOpacity(0.72)
                                    : status == 'PENDING' ||
                                            status == 'PROCESSING'
                                        ? const Color(0xffB5B816)
                                            .withOpacity(0.72)
                                        : const Color(0xffEB1717)
                                            .withOpacity(0.72),
                              ),
                              charges != null || charges != ''
                                  ? AppText.body6L(
                                      'Charges:${asset == 'NAIRA' ? 'N$charges' : '$charges$asset'}',
                                      color: kSecondaryColor,
                                      multitext: true)
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AppText.body4L(asset == 'NAIRA'
                        ? type == 'WITHDRAWAL'
                            ? 'To: $fromWho'
                            : type == 'ELECTRICITY'
                                ? 'Token: $eToken'
                                : ''
                        : type == 'SEND'
                            ? 'To: $fromWho'
                            : type == 'RECIEVED'
                                ? 'From: $fromWho'
                                : ''),
                  ],
                ),
              ),
              const Divider(
                color: kBorderColor,
                thickness: 1,
                //width:double.infinity
              )
            ],
          );
  }
}
