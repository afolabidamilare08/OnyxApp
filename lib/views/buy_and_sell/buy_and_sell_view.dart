import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/buy_and_sell/components/buy.dart';
import 'package:onyxswap/views/buy_and_sell/components/sell.dart';
import 'package:onyxswap/views/buy_and_sell/viewmodel/buy_viewmodel.dart';
import 'package:onyxswap/widgets/background_widget.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

import '../../core/constants/custom_icons.dart';
import '../../utils/color.dart';

final _buyViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => BuyViewModel());

// ignore: must_be_immutable
class BuyAndSellView extends ConsumerStatefulWidget {
  BuyAndSellView({
    Key? key,
    this.isBuyTapped,
  }) : super(key: key);
  bool? isBuyTapped;

  @override
  ConsumerState<BuyAndSellView> createState() => _BuyAndSellViewState();
}

TextEditingController ngnController = TextEditingController();
TextEditingController usdController = TextEditingController();
TextEditingController btcController = TextEditingController();
TextEditingController ngnControllers = TextEditingController();
TextEditingController usdControllers = TextEditingController();
TextEditingController btcControllers = TextEditingController();
TextEditingController pin = TextEditingController();
TextEditingController twoFA = TextEditingController();

class _BuyAndSellViewState extends ConsumerState<BuyAndSellView> {
  @override
  // ignore: unused_element
  initState() {
    widget.isBuyTapped = widget.isBuyTapped ?? true;
    Future.delayed(Duration.zero, ref.read(_buyViewmodel).getBalance);
    Future.delayed(
        Duration.zero, () => ref.read(_buyViewmodel).getMarketValue());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    ngnController.clear();
    usdController.clear();
    btcController.clear();
    ngnControllers.clear();
    usdControllers.clear();
    btcControllers.clear();
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(_buyViewmodel);

    return LoaderPage(
      loading: model.isLoading,
      child: BackgroundWidget(
          flexibleSpace: 206,
          loading: model.isLoading,
          flexibleChild: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    NyxIcons.arrow_back,
                    color: kSecondaryColor,
                    size: 20,
                  ),
                ),
                AppText.heading2L(
                  "Balance",
                ),
                SizedBox(
                  width: 2,
                )
              ]),
              const SizedBox(
                height: 25,
              ),
              AppText.heading3L(
                "NGN ${model.nairabalance ?? '0.00'}",
                color: kSecondaryColor,
              ),
              const SizedBox(
                height: 44,
              )
            ],
          ),
          onTapBuy: () {
            widget.isBuyTapped = true;
            setState(() {});
          },
          onTapSell: () {
            widget.isBuyTapped = false;
            setState(() {});
          },
          buyIsTapped: widget.isBuyTapped,
          buyAndSell: true,
          sendAndRecieve: false,
          children: [
            if (widget.isBuyTapped!)
              Form(
                key: model.formKey,
                child: Buy(
                  btcController: btcController,
                  ngnController: ngnController,
                  usdController: usdController,
                  otherText: '${model.assetprice} ${model.asset}',
                  nairaBalance: 'N${model.nairabalance}',
                  dropdown: model.buildDropDown(
                      type: 'BUY',
                      context: context,
                      assetController: btcController,
                      ngnController: ngnController,
                      usdController: usdController),
                  rate: model.buyrate ?? '1',
                  charges: model.buycharges ?? '1',
                  marketPrice: model.marketprice ?? '1',
                  asset: model.asset == 'USDT_TRON' ? 'USDT' : model.asset,
                  loading: model.isLoading,
                  maxpressed: () =>
                      ngnController.text = model.nairabalance ?? '0.00',
                  onTap: () {
                    model.twoFA(
                        assetamount: btcController.text,
                        amount: ngnController.text,
                        usdprice: usdController.text,
                        currentAsset: model.asset,
                        pin: pin,
                        twoFA: twoFA,
                        type: 'buy');
                    // ngnController.clear();
                    // btcController.clear();
                    // usdController.clear();
                    pin.clear();
                  },
                ),
              )
            else
              Form(
                key: model.formKey,
                child: Sell(
                  btcController: btcControllers,
                  ngnController: ngnControllers,
                  usdController: usdControllers,
                  charges: model.sellcharges ?? '1',
                  otherText: '${model.assetprice} ${model.asset}',
                  nairaBalance: 'N${model.nairabalance}',
                  dropdown: model.buildDropDown(
                      type: 'sell',
                      context: context,
                      assetController: btcControllers,
                      ngnController: ngnControllers,
                      usdController: usdControllers),
                  rate: model.sellrate ?? '1',
                  marketPrice: model.marketprice ?? '1',
                  asset: model.asset == 'USDT_TRON' ? 'USDT' : model.asset,
                  btnText: model.btnText,
                  onTap: () {
                    model.twoFA(
                        assetamount: btcControllers.text,
                        amount: ngnControllers.text,
                        usdprice: usdControllers.text,
                        currentAsset: model.asset,
                        pin: pin,
                        twoFA: twoFA,
                        type: 'BUY');
                    // ngnControllers.clear();
                    // btcControllers.clear();
                    // usdControllers.clear();
                    pin.clear();
                    twoFA.clear();
                  },
                ),
              )
          ]),
    );
  }
}
