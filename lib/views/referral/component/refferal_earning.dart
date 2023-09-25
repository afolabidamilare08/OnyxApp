import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';

class RefferalEarning extends StatelessWidget {
  const RefferalEarning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (() => Navigator.pop(context)),
                        child: Icon(Icons.arrow_back,color: kSecondaryColor,)),
                    
                      AppText.heading1L('Referal Earnings',color: kSecondaryColor,),
                      SizedBox(width:40)
                    ],
                  ),
                  const SizedBox(height: 60,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.body10L('Earning this WEEK'),
                      const SizedBox(height: 7,),
                      AppText.body2L('NGN 0.00'),
                      const SizedBox(height: 45,),
                      AppText.body10L('Total EARNING'),
                      const SizedBox(height: 7,),
                      AppText.body2L('NGN 0.00'),
                      const SizedBox(height: 45,),
                      AppText.body10L('NEXT PAYOUT DATE'),
                      const SizedBox(height: 7,),
                      AppText.body2L('7/24/2022'),
                      const SizedBox(height: 45,),
                      AppText.body10L('No of REFERRALS'),
                      const SizedBox(height: 7,),
                      AppText.body2L('0'),
      
                    ],
                  )
            ],
          ),
        ),
      ),
    );
  }
}