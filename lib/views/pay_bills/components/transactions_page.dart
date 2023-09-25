import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/pay_bills/components/transaction_widget.dart';
import 'package:onyxswap/views/pay_bills/viewmodels/all_transaction.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

final _allTransactions =
    ChangeNotifierProvider.autoDispose((ref) => AllTransactions());

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(_allTransactions);
    return Scaffold(
        body: SafeArea(
            child: RefreshIndicator(
      onRefresh:()async=> await model.allTransaction(),
      child: LoaderPage(
        loading: model.isLoading,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    NyxIcons.arrow_back,
                    color: kSecondaryColor,
                  )),
              AppText.heading2N(
                'Transactions',
                color: kSecondaryColor,
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
          Expanded(
              child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
                child: model.transactions.isEmpty
                    ? AppText.heading5N(
                        'No Transactions Yet',
                        color: kSecondaryColor,
                        centered: true,
                      )
                    : Column(children: [
                        ...List.generate(
                            model.transactions.length,
                            (index) => TransactionWidget(
                                biller: model.transactions[index][2],
                                amount: model.transactions[index][5],
                                type: model.transactions[index][3],
                                number: model.transactions[index][4],
                                date: model.transactions[index][6],
                                mainToken: model.transactions[index][2]=='Electricity Bill'? model.transactions[index][7]:'' ,
                                )),
                      ]))
          ]))
        ]),
      ),
    )));
  }
}
