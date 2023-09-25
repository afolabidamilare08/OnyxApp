import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/buy_and_sell/components/buy_and_sell_texfield.dart';
import 'package:onyxswap/widgets/app_button.dart';

import '../viewmodel/buy_viewmodel.dart';

final _buyViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => BuyViewModel());

class Sell extends ConsumerStatefulWidget {
  const Sell(
      {Key? key,
      required this.btcController,
      required this.ngnController,
      required this.usdController,
      required this.dropdown,
      required this.charges,
      required this.otherText,
      required this.nairaBalance,
      required this.rate,
      required this.marketPrice,
      required this.btnText,
      required this.onTap,
      required this.asset})
      : super(key: key);
  final TextEditingController ngnController;
  final TextEditingController usdController;
  final TextEditingController btcController;
  final Widget dropdown;
  final String rate;
  final String nairaBalance;
  final String otherText;
  final String charges;
  final String asset;
  final String btnText;
  final String marketPrice;
  final Function() onTap;
  @override
  ConsumerState<Sell> createState() => _SellState();
}

class _SellState extends ConsumerState<Sell> {
  @override
  void initState() {
    //    Future.delayed(Duration.zero, ref.read(_buyViewmodel).getBalance);
    // Future.delayed(
    //     Duration.zero, () => ref.read(_buyViewmodel).getMarketValue('SELL'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  AppButton(
                    title: 'Naira Wallet',
                    height: 44,
                    width: MediaQuery.of(context).size.width / 2.5,
                  )
                ],
              ),
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
              enableMax: false,
              headingText: "You sell",
              otherText: widget.otherText,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please input a valid number';
                } else if (double.tryParse(value)! <= 0) {
                  return 'Please input a number greater than 0';
                } else {
                  return null;
                }
              },
              currAbbrv: widget.asset,
              readonly: false,
              controller: widget.btcController,
              onchanged: (value) {
                setState(() {
                  double gottenValue;
                  if (value!.isEmpty) {
                    widget.usdController.text = value;
                    widget.ngnController.text = value;
                  } else {
                    String passedValue = value;
                    gottenValue = (double.parse(passedValue) *
                        double.parse(widget.marketPrice));
                    widget.usdController.text = gottenValue.toString();
                    // String passedValue = value ?? '0';
                    double? gottenValue2 =
                        double.parse(widget.usdController.text) *
                            double.parse(widget.rate);
                    widget.ngnController.text = gottenValue2.toString();
                  }
                });
              }),
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
            enableMax: true,
            headingText: "You get",
            otherText: widget.nairaBalance,
            currAbbrv: "NGN",
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
            controller: widget.ngnController,
          ),
          const SizedBox(
            height: 22,
          ),
          BuyAndSellTextField(
            enableMax: false,
            headingText: "You get",
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please input a valid number';
              } else if (double.tryParse(value)! <= 0) {
                return 'Please input a number greater than 0';
              } else {
                return null;
              }
            },
            currAbbrv: "USD",
            readonly: true,
            controller: widget.usdController,
          ),
          const SizedBox(
            height: 32,
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
            title: widget.btnText,
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
