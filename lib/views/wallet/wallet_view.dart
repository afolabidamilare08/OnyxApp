import 'dart:async';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/core/constants/routeargument_key.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/utils/app_colors.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/wallet/components/balance_card.dart';
import 'package:onyxswap/views/wallet/components/coin_squarecard.dart';
import 'package:onyxswap/views/wallet/components/coin_widecard.dart';
import 'package:onyxswap/views/wallet/viewmodel/wallet_viewmodel.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

import '../../data/local/local_cache/local_cache.dart';
import '../../utils/locator.dart';
import '../wallets/usdtwallet.dart';

final _wallletViewModelProvider =
    ChangeNotifierProvider.autoDispose((ref) => WalletViewModel());
NavigationService _navigationService = NavigationService.I;

class WalletView extends ConsumerStatefulWidget {
  const WalletView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WalletViewState();
}

class _WalletViewState extends ConsumerState<WalletView> {
  final LocalCache _localCache = locator<LocalCache>();
  List<Object?> savedPrices = ['1', '2', '3'];
  List<Object?> savedBalances = ['0.00', '0.00', '0.00', '0.00'];
  List<Object?> nairasaves =['', '\$0.00', '\$0.00', '\$0.00'] ;

  // @override
  // void dispose() {
  //   ref.read(_wallletViewModelProvider).dispose();
  //   super.dispose();
  // }

  @override
  void didChangeDependencies() {
    ref.read(_wallletViewModelProvider).streamgetter;
    //ref.read(_wallletViewModelProvider).dispose();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // Future.delayed(Duration.zero,
    //     () => ref.read(_wallletViewModelProvider).fetchMarketPrices(context));
    // Future.delayed(
    //     Duration.zero, ref.read(_wallletViewModelProvider).createAssets);
    // Future.delayed(Duration.zero,
    //     () => ref.read(_wallletViewModelProvider).fetchNairawallet());
    // Future.delayed(
    //     Duration.zero, () => ref.read(_wallletViewModelProvider).getBalance());
    // // ref.read(_wallletViewModelProvider).getBalance();

    // ref.read(_wallletViewModelProvider).getFullname();

    setState(() {
      if (_localCache.getFromLocalCache('prices') != null) {
        savedPrices = _localCache.getFromLocalCache('prices') as List<Object?>;
      }
      if (_localCache.getFromLocalCache('balances') != null) {
        savedBalances =
            _localCache.getFromLocalCache('balances') as List<Object?>;
      }
      if(_localCache.getFromLocalCache('walletbalance')!=null){
         nairasaves =
            _localCache.getFromLocalCache('walletbalance') as List<Object?>;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var model = ref.watch(_wallletViewModelProvider);
    print(MediaQuery.of(context).size.width);
    model.mounted = mounted;
    return ColorfulSafeArea(
      color: AppColors.backgroundColor,
      child: Scaffold(
        key: model.scaffoldKey,
        body: RefreshIndicator(
          onRefresh: () {
            return model.getBalance();
          },
          child: LoaderPage(
            loading: model.isLoading,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.body2L("Hello ${model.fullname ?? ''},"),
                              const SizedBox(
                                height: 8,
                              ),
                              AppText.heading1L("Welcome!!"),
                            ],
                          ),
                          const Spacer(),
                          // Container(
                          //   clipBehavior: Clip.hardEdge,
                          //   width: 42,
                          //   height: 42,
                          //   decoration:
                          //       const BoxDecoration(shape: BoxShape.circle),
                          //   child: CachedNetworkImage(
                          //     fit: BoxFit.cover,
                          //     imageUrl:
                          //         "https://images.pexels.com/photos/2050994/pexels-photo-2050994.jpeg",
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 33,
                      ),
                      BalanceCard(
                          balance: model.nairabalance ?? '0.00',
                          cancel: () {} //model.timer.cancel,
                          ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          AppText.heading2L("Wallet"),
                          const Spacer(),
                          // InkWell(
                          //     onTap: (() {
                          //       _navigationService
                          //           .navigateTo(NavigatorRoutes.wallet);
                          //     }),
                          //     child: AppText.body4L("view all")),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            //CoinSquareCard(icon: model.icon, title: title, sign: sign)
                            ...List.generate(
                                4,
                                (index) => GestureDetector(
                                    onTap: index == 0
                                        ? () async {
                                            // model.timer.cancel();
                                            await model
                                                .createNairaWallet(context);
                                          }
                                        : () {
                                            //model.timer.cancel();
                                            NavigationService.I.navigateTo(
                                                NavigatorRoutes.usdtWallet,
                                                argument: {
                                                  RouteArgumentkeys.asset:
                                                      model.title[index],
                                                  RouteArgumentkeys.usdtBalance:
                                                      model
                                                          .walletBalance.isNotEmpty?model.walletBalance[index]:nairasaves[index],
                                                  RouteArgumentkeys
                                                      .balance: model
                                                          .gottenBalance.isEmpty
                                                      ? savedBalances[index]
                                                          .toString()
                                                      : model
                                                          .gottenBalance[index]
                                                });
                                          },
                                    //  Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             USDTwallet(
                                    //               asset: model.title[index]
                                    //                   .toLowerCase(),
                                    //               balance: model
                                    //                       .gottenBalance
                                    //                       .isEmpty
                                    //                   ? savedBalances[index]
                                    //                       .toString()
                                    //                   : model.gottenBalance[
                                    //                       index],
                                    //             ))),
                                    child: CoinSquareCard(
                                        icon: model.icons[index],
                                        title: model.title[index],
                                        balance: model.walletBalance.isEmpty
                                            ? nairasaves[index].toString()
                                            : model.walletBalance[index].toString(),
                                        sign: model.sign[index],
                                        price: model.gottenBalance.isEmpty
                                            ? savedBalances[index].toString()
                                            : model.gottenBalance[index].toString())))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          AppText.heading2L("Trends"),
                          const Spacer(),
                          // InkWell(
                          //     onTap: (() {
                          //       _navigationService
                          //           .navigateTo(NavigatorRoutes.trends);
                          //     }),
                          //     child: AppText.body4L("view all"))
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ...List.generate(
                          3,
                          (index) => CoinWideCard(
                                coin: model.coins[index],
                                symbol: model.symbols[index],
                                icon: model.icon[index],
                                price: model.prices.isEmpty
                                    ? savedPrices[index].toString()
                                    : model.prices[index],
                              ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
