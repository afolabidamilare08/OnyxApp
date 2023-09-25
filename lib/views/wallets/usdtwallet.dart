// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/wallets/component/container_widget.dart';
import 'package:onyxswap/views/wallets/viewmodel/wallet_viewmodel.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/background_widget.dart';
import 'package:onyxswap/widgets/loaderpage.dart';
import 'package:sliver_tools/sliver_tools.dart';

final _walletViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => WalletViewModels());

class USDTwallet extends ConsumerStatefulWidget {
  const USDTwallet(
      {Key? key,
      required this.asset,
      required this.balance,
      required this.usdtbalance})
      : super(key: key);
  final String asset;
  final String balance;
  final String usdtbalance;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _USDTwalletState();
}

class _USDTwalletState extends ConsumerState<USDTwallet> {
  bool isObsured = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,
        () => ref.read(_walletViewmodel).getTransaction(widget.asset, context));
  }

  @override
  Widget build(BuildContext context) {
    NavigationService _navigationService = NavigationService.I;
    String finalBal = double.tryParse(widget.balance)!.toStringAsFixed(5);

    //String finalUSDBal = double.tryParse(widget.usdtbalance)!.toStringAsFixed(5);
    var model = ref.watch(_walletViewmodel);
    return BackgroundWidget(
        flexibleChild: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xffCCD2E3)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      AppText.heading6L(
                        '${widget.asset.toUpperCase()} Wallet',
                        color: Colors.white,
                        centered: true,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      !isObsured
                          ? AppText.heading6L(
                              '$finalBal ${widget.asset.toUpperCase()}',
                              color: Colors.white,
                            )
                          : AppText.heading6L(
                              '****** ${widget.asset.toUpperCase()}',
                              color: Colors.white,
                            ),
                      const SizedBox(
                        width: 21,
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          isObsured = !isObsured;
                        }),
                        child: Icon(
                          isObsured ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  AppText.body3L(
                    widget.usdtbalance,
                    color: kSecondaryColor,
                  )
                ],
              ),
            ),
            SizedBox(
              width: 40,
            )
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
                  onRefresh: () => model.getTransaction(widget.asset, context),
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
                                onPressed: () =>
                                    model.getTransaction(widget.asset, context),
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
                        child: model.transactions.isNotEmpty
                            ? Column(
                                children: [
                                  ...List.generate(
                                      model.transactions.length,
                                      (index) => ContainerWidget(
                                            asset: widget.asset.toUpperCase(),
                                            status: model.transactions[index]
                                                        [10] ==
                                                    0
                                                ? 'PENDING'
                                                : model.transactions[index]
                                                            [10] ==
                                                        1
                                                    ? 'SUCCESS'
                                                    : 'CANCELLED',
                                            date: model.transactions[index][4]
                                                .toString(),
                                            //'${DateFormat.yMMMMd().format(model.transactions[index][4])} ${DateFormat.jm().format(model.transactions[index][4])}',
                                            amount: model.transactions[index][8]
                                                .toString(),
                                            type: model.transactions[index][9],
                                            fromWho: model.transactions[index]
                                                [11],
                                            charges: model.transactions[index]
                                                        [19] ==
                                                    ''
                                                ? '0.0'
                                                : double.parse(model
                                                        .transactions[index][19]
                                                        .toString())
                                                    .toStringAsFixed(9),

                                            // status: model.transactions[index]

                                            // date: '${DateFormat.yMMMd().format(
                                            //   DateTime.parse(
                                            //       model.transactions[index]
                                            //           ['createdAt']),
                                            // )} ${DateFormat.jm().format(
                                            //   DateTime.parse(
                                            //       model.transactions[index]
                                            //           ['createdAt']),
                                            // )}',
                                            // amount: model.transactions[index]
                                            //         ['amount']
                                            //     .toString(),
                                            // fromWho: model.transactions[index]['fromAddress'],
                                            // type: model.transactions[index]
                                            //     ['type']
                                          ))
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    AppText.heading1L(
                                      'No Transactions Yet',
                                      color: kSecondaryColor,
                                      centered: true,
                                    ),
                                  ]),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                onTap: () =>
                    _navigationService.navigateTo(NavigatorRoutes.send),
                title: 'Send',
                height: 51,
                width: MediaQuery.of(context).size.width / 2.84 - 24,
              ),
              //const SizedBox(width: 24,),
              SizedBox(
                width: 24,
              ),
              AppButton(
                onTap: () =>
                    _navigationService.navigateTo(NavigatorRoutes.send),
                title: 'Recieve',
                height: 51,
                width: MediaQuery.of(context).size.width / 2.84 - 24,
              ),
            ],
          ),
        ]);
  }
}
