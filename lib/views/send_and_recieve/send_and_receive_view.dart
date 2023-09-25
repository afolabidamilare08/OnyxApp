// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/send_and_recieve/components/receive.dart';
import 'package:onyxswap/views/send_and_recieve/components/send.dart';
import 'package:onyxswap/views/send_and_recieve/viewmodel/send_viewmodel.dart';
import 'package:onyxswap/widgets/background_widget.dart';
import 'package:onyxswap/widgets/loaderpage.dart';
import 'package:onyxswap/widgets/pin_bottomsheet.dart';

import '../../utils/color.dart';
import '../../utils/text.dart';

final _sendViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => SendAndRecieveViewmodel());

class SendAndReceiveView extends ConsumerStatefulWidget {
  SendAndReceiveView({Key? key, this.isBuyTapped}) : super(key: key);
  bool? isBuyTapped;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendAndReceiveViewState();
}

TextEditingController reciever = TextEditingController();
TextEditingController amount = TextEditingController();
TextEditingController twoFa = TextEditingController();

TextEditingController pin = TextEditingController();

class _SendAndReceiveViewState extends ConsumerState<SendAndReceiveView> {
  @override
  void initState() {
    ref.read(_sendViewmodel).onTap('BTC', context);
    //ref.read(_sendViewmodel).getMarketValue();
    super.initState();
  }

  // @override
  // void dispose() {
  //   reciever.dispose();
  //   amount.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(_sendViewmodel);
    return LoaderPage(
      loading: model.isLoading,
      child: BackgroundWidget(
          flexibleSpace: 120,
          flexibleChild: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: (() => Navigator.pop(context)),
                icon: const Icon(
                  CupertinoIcons.arrow_left,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  size: 24,
                ),
              ),
              // model.asset != null
              //     ? Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           AppText.heading2L(
              //             "Balance",
              //           ),
              //           SizedBox(
              //             width: 2,
              //           ),

              //           // const SizedBox(
              //           //   height: 25,
              //           // ),
              //           AppText.heading2L(
              //             model.asset == 'USDT_TRON'
              //                 ? "${model.assetPrice} USDT"
              //                 : "${model.assetPrice} ${model.asset}",
              //             color: kSecondaryColor,
              //           ),
              //           AppText.heading2L(
              //             "\$ ${model.usdPrice}",
              //             color: kSecondaryColor,
              //           ),
              //         ],
              //       )
              //     : SizedBox(),
              //   const SizedBox(
              //     height: 44,
              //   )
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
          buyAndSell: false,
          sendAndRecieve: true,
          children: [
            if (widget.isBuyTapped!)
              Send(
                  recipient: reciever,
                  balance: model.assetPrice,
                  amount: amount,
                  network: model.buildDropdown(context),
                  haserror: model.haserror,
                  formkey: model.formKey,
                  charges: model.charges,
                  ontap: () => model.twoFA(
                      twoFA: twoFa,
                      pin: pin,
                      amount: amount.text,
                      reciever: reciever.text,
                      context: context,
                      type: model.asset ?? ''))
            else
              Receive(
                title: model.assets,
                //selectedType: model.selected,
                // ontap:  model.onTap(model.selected),
                data: model.address,
              ),
          ]),
    );
  }
}
