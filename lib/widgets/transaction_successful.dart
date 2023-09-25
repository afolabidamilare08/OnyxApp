import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/widgets/app_button.dart';

import '../core/routes/routing_constants.dart';
import '../utils/text.dart';

class TransactionSuccessful extends StatelessWidget {
  const TransactionSuccessful({Key? key, required this.heading, required this.subHeading,  this.onTap}) : super(key: key);
final String heading;
final String subHeading;
final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 100, 25, 100),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(
              children: [
                  AppText.heading1L(
                heading,
                color: kSecondaryColor,
              ),
              const SizedBox(height: 21,),
              AppText.body2L(
                subHeading,
                color: kSecondaryColor,
                multitext: true,
                centered: true,
              ),
              ],
            ),
              Container(
                height: 237,
                width: 237,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: kSecondaryColor),
                child: const Icon(
                  Icons.check_sharp,
                  size: 105,
                  color: kPrimaryColor,
                ),
              ),
               AppButton(
                title: 'Continue',
                height: 61,
                borderRadius: 40,
                onTap: onTap??()=>Navigator.popUntil(context,
                          ModalRoute.withName(NavigatorRoutes.homeView)),
              ),
              // Column(
              //   children: [
              //     AppText.body4L(
              //       'By clicking continue, you agree to our ',
              //       color: kSecondaryColor,
              //     ),
              //     AppText.body4L(
              //       'Terms and Conditions ',
              //       color: kSecondaryColor,
              //     )
              //   ],
              // )
            ]),
      ),
    ));
  }
}
