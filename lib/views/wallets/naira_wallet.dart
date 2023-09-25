// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/wallets/component/container_widget.dart';

import 'package:onyxswap/views/wallets/viewmodel/wallet_viewmodel.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/background_widget.dart';
import 'package:onyxswap/widgets/loaderpage.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'component/withdraw.dart';

final _walletViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => WalletViewModels());

class NairaWallet extends ConsumerStatefulWidget {
  const NairaWallet({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NairaWalletState();
}

class _NairaWalletState extends ConsumerState<NairaWallet> {
  bool isObsured = false;
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () =>
            ref.read(_walletViewmodel).getTransaction('nairawallet', context));
    Future.delayed(Duration.zero, () => ref.read(_walletViewmodel).getBalance);

    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var model = ref.watch(_walletViewmodel);
    String date(int index) {
      if (model.transactions.isNotEmpty) {
        String date =
            model.transactions[index][4].split(',')[1].split(' ').join('-');
        DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
        DateTime dateTime = dateFormat.parse('09-12-2022 10:25:43');
        var time = DateFormat.jm().format(model.transactions[index][4]);
        return '$dateTime $time';
      } else {
        return '';
      }
    }

    return BackgroundWidget(
        flexibleChild: Column(
          children: [
            SizedBox(height: 50),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: kSecondaryColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        AppText.heading6L(
                          'Naira Wallet',
                          color: Colors.white,
                          centered: true,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        // AppText.heading6L(
                        //   'NGN ${model.getBalance()}',
                        //   color: Colors.white,
                        // ),
                        // const SizedBox(
                        //   width: 21,
                        // ),
                        // const Icon(
                        //   Icons.visibility_off,
                        //   color: Colors.white,
                        // )
                        !isObsured
                            ? AppText.heading6L(
                                'NGN ${model.getBalance()}',
                                color: Colors.white,
                              )
                            : AppText.heading6L(
                                'NGN ******',
                                color: Colors.white,
                              ),
                        const SizedBox(
                          width: 21,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isObsured = !isObsured;
                            });
                            print(isObsured);
                          },
                          child: Icon(
                            isObsured ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: 50,
                )
              ],
            ),
          ],
        ),
        flexibleSpace: 147,
        buyAndSell: false,
        sendAndRecieve: false,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.8,
              child: LoaderPage(
                loading: model.isLoading,
                child: RefreshIndicator(
                  onRefresh: () => model.getTransaction('nairawallet', context),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: CustomScrollView(
                      slivers: [
                        SliverPinnedHeader(
                          child: Container(
                            color: kBlackColor,
                            child: Row(
                              children: [
                                AppText.body4L(
                                  'Transaction History',
                                  color: kSecondaryColor,
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => model.getTransaction(
                                      'nairawallet', context),
                                  child: AppText.body4L(
                                    'Update',
                                    color: kSecondaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 25,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Center(
                              child: model.transactions.isEmpty
                                  ? AppText.heading7L(
                                      'No Transactions Yet',
                                      color: kSecondaryColor,
                                    )
                                  : Column(
                                      children: [
                                        ...List.generate(
                                            model.transactions.length,
                                            (index) => ContainerWidget(
                                                asset: 'NAIRA',
                                                fromWho: model
                                                    .transactions[index][12],
                                                eToken: model
                                                    .transactions[index][7],
                                                status: model.transactions[index]
                                                            [10] ==
                                                        0
                                                    ? 'PENDING'
                                                    : model.transactions[index]
                                                                [10] ==
                                                            1
                                                        ? 'SUCCESS'
                                                        : 'CANCELLED',
                                                date: model.transactions[index]
                                                        [4]
                                                    .toString(),
                                                    charges:model.transactions[index][19]==''?'0.0': double.parse(model.transactions[index][19].toString()).toStringAsFixed(9),
                                                //'${DateFormat.yMMMMd().format(model.transactions[index][4])} ${DateFormat.jm().format(model.transactions[index][4])}',
                                                amount: model.transactions[
                                                            index][5] !=
                                                        null
                                                    ? double.tryParse(
                                                        model
                                                            .transactions[index]
                                                                [5]
                                                            .toString(),
                                                      )!
                                                        .toStringAsFixed(2)
                                                    : '',
                                                type: model.transactions[index]
                                                    [9]
                                                // model.transactions[index]
                                                //     [9]=='SEND'||model.transactions[index]
                                                //     [9]=='RECIEVED'?model.transactions.remove(index):model.transactions[index]
                                                //     [9]
                                                )),
                                        // DateFormat.yMMMMd().format(model.transactions[0][4])
                                      ],
                                    )),
                        )
                        // ContainerWidget(isNaira: true, status: 'SUCCESSFUL'),
                        // ContainerWidget(isNaira: true, status: 'SUCCESSFUL'),
                        // ContainerWidget(isNaira: true, status: 'PENDING'),
                        // ContainerWidget(isNaira: true, status: 'FAILED'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  title: 'Deposit',
                  onTap: () {
                    model.nairaDeposit(context);
                  },
                  width: MediaQuery.of(context).size.width / 2.84 - 24,
                  height: 51,
                ),
                SizedBox(
                  width: 24,
                ),
                AppButton(
                  title: 'Withdraw',
                  height: 51,
                  width: MediaQuery.of(context).size.width / 2.84 - 24,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WithdrawScreen())),
                )
              ],
            ),
          )
        ]);
  }
}
