import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/buy_and_sell/components/buy_and_sell_texfield.dart';

import 'package:onyxswap/widgets/app_button.dart';

import '../viewmodel/buy_viewmodel.dart';

final _buyViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => BuyViewModel());

class Buy extends ConsumerStatefulWidget {
  const Buy(
      {Key? key,
      required this.btcController,
      required this.ngnController,
      required this.loading,
      required this.usdController,
      required this.dropdown,
      required this.otherText,
      required this.nairaBalance,
      required this.rate,
      required this.marketPrice,
      required this.charges,
      required this.asset,
      this.maxpressed,
      required this.onTap})
      : super(key: key);
  final TextEditingController ngnController;
  final TextEditingController usdController;
  final TextEditingController btcController;
  final Widget dropdown;
  final String rate;
  final String asset;
  final String nairaBalance;
  final String otherText;
  final String charges;
  final String marketPrice;
  final Function() onTap;
  final bool loading;
  final Function()? maxpressed;
  @override
  ConsumerState<Buy> createState() => _BuyState();
}

String text = 'BTC';
List<String> items = ['BTC', 'USDT', 'BUSD'];

class _BuyState extends ConsumerState<Buy> {
  @override
  void initState() {
    //   Future.delayed(Duration.zero, ref.read(_buyViewmodel).getBalance);
    // Future.delayed(
    //     Duration.zero, () => ref.read(_buyViewmodel).getMarketValue());
    super.initState();
  }
  // @override
  // void initState() {
  //   Timer.periodic(
  //       Duration(hours: 1), (timer) => ref.read(_buyViewmodel).getMarketValue);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //var model = ref.watch(_buyViewmodel);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 52,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.body3L(
                    '    From',
                    color: kSecondaryColor,
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  AppButton(
                    title: 'Naira Wallet',
                    height: 44,
                    width: MediaQuery.of(context).size.width / 2.5,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.body3L(
                    '    To',
                    color: kSecondaryColor,
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      height: 44,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kAccentColor),
                      child:
                          DropdownButtonHideUnderline(child: widget.dropdown)),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          AppButton(
            width: double.infinity,
            title: 'Rate: ${widget.rate}/\$',
          ),
          const SizedBox(
            height: 36,
          ),
          BuyAndSellTextField(
            enableMax: true,
            headingText: "You pay",
            currAbbrv: "NGN",
            otherText: widget.nairaBalance,
            controller: widget.ngnController,
            maxPressed: widget.maxpressed,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please input a valid number';
              } else if (double.tryParse(value)! <= 0) {
                return 'Please input a number greater than 0';
              } else {
                return null;
              }
            },
            readonly: false,
            onchanged: (value) {
              setState(() {
                double gottenValue;
                if (value!.isEmpty) {
                  widget.usdController.text = value;
                  widget.btcController.text = value;
                } else {
                  String passedValue = value;
                  gottenValue =
                      (double.parse(passedValue) / double.parse(widget.rate));
                  widget.usdController.text = gottenValue.toString();
                  // String passedValue = value ?? '0';
                  double? gottenValue2 =
                      double.parse(widget.usdController.text) /
                          double.parse(widget.marketPrice);
                  widget.btcController.text = gottenValue2.toString();
                }
              });
            },
          ),
          //  const SizedBox(
          //   height: 8,
          // ),
          // AppText.body4L(
          //   'Please Note that 25 naira will be charged for this transaction',
          //   color: kSecondaryColor,
          //   centered: false,
          // ),
          const SizedBox(
            height: 22,
          ),
          BuyAndSellTextField(
            enableMax: false,
            headingText: "Equivalent",
            currAbbrv: "USD",
            readonly: true,
            controller: widget.usdController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please input a valid number';
              } else if (double.tryParse(value)! <= 0) {
                return 'Please input a number greater than 0';
              } else {
                return null;
              }
            },
            onchanged: (value) {
              setState(() {
                String passedValue = value ?? '0';
                double? gottenValue = double.parse(passedValue) /
                    double.parse(widget.marketPrice);
                widget.btcController.text = gottenValue.toString();
              });
            },
          ),
          const SizedBox(
            height: 32,
          ),
          const Center(
              child: Icon(
            Icons.currency_exchange,
            size: 32,
            color: kSecondaryColor,
          )),
          const SizedBox(
            height: 32,
          ),
          BuyAndSellTextField(
            enableMax: false,
            headingText: "You get",
            otherText: widget.otherText,
            currAbbrv: widget.asset,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please input a valid number';
              } else if (double.tryParse(value)! <= 0) {
                return 'Please input a number greater than 0';
              } else {
                return null;
              }
            },
            readonly: true,
            controller: widget.btcController,
          ),
          const SizedBox(
            height: 10,
          ),
          AppText.body3L(
            'Charges: ${widget.charges}%',
            color: kSecondaryColor,
          ),
          const SizedBox(
            height: 52,
          ),
          AppButton(
            title: "Buy",
            onTap: widget.onTap,
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
