import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/pay_bills/components/bill_card.dart';
import 'package:onyxswap/views/pay_bills/components/transactions_page.dart';

class PayBillsView extends StatefulWidget {
  const PayBillsView({Key? key}) : super(key: key);

  @override
  State<PayBillsView> createState() => _PayBillsViewState();
}

class _PayBillsViewState extends State<PayBillsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 28,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // IconButton(
                        //     onPressed: () => Navigator.pop(context),
                        //     icon: Icon(
                        //       NyxIcons.arrow_back,
                        //       color: kSecondaryColor,
                        //       size: 20,
                        //     )),
                        SizedBox(
                          width: 20,
                        ),
                        AppText.heading1L("Pay Bills"),
                        GestureDetector(
                          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>TransactionsPage())),
                          child: AppText.body3P(
                            'History',
                            color: kSecondaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: List.generate(
                        3,
                        (index) => BillCard(index: index),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
