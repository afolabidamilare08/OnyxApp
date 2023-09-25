import 'package:flutter/material.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({
    Key? key,
    required this.biller,
    required this.amount,
    required this.type,
    required this.number,
    this.mainToken,
    required this.date,
  }) : super(key: key);
  final String biller;
  final String type;
  final String number;
  final String amount;
  final String date;
  final String? mainToken;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kBorderColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText.body2L(
            biller,
            color: kSecondaryColor,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.body2L(
                type,
                color: kSecondaryColor,
              ),
              AppText.body4L(
                'N$amount',
                color: kSuccessColor,
              ),
              AppText.body4L(
                number,
                color: kSecondaryColor,
              ),
              AppText.body4L(
                mainToken ?? '',
                color: kSecondaryColor,
              ),
              AppText.body4L(
                date,
                color: kSecondaryColor,
              ),
            ],
          )
        ],
      ),
    );
  }
}
