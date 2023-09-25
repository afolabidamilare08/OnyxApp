import 'package:barcode_widget/barcode_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/flushbar.dart';
import '../view_model/two_factor_viewmodel.dart';
final _vm=ChangeNotifierProvider.autoDispose((ref) => TwoFactorViewModel());
class TwoFactorAuthentication extends ConsumerWidget {
  const TwoFactorAuthentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var model = ref.watch(_vm);
    return Scaffold(
      body: SafeArea(
        child: LoaderPage(
          loading: model.isLoading,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_back,
                              color: kSecondaryColor,
                            )),
                        AppText.heading1L(
                          'Two-Factor Authentication',
                          multitext: true,
                          maxlines: 2,
                          color: kSecondaryColor,
                        ),
                        // SizedBox(
                        //   width: 40,
                        // )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText.heading7L(
                      'Setup your two-factor authentication pin',
                      multitext: true,
                      color: kSecondaryColor,
                      centered: true,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 42,
                ),
                AppText.body2L(
                  'A.  Enabling 2-factor authentication involves you downloading the Google authenticator app on your phone(Android or Ios). This app will generate a 6 digit code that you will during transactions in your account. This code changes every 30 seconds.Every time you want to buy and sell, thereby verifying your account You can download the app from the playstore or appstore',
                  multitext: true,
                  color: kSecondaryColor,
                  centered: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                AppText.body2L(
                  'B.  To setup 2-factor authentication, Please click next and follow the instructions',
                  multitext: true,
                  color: kSecondaryColor,
                  centered: false,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                AppButton(
                  title: 'Next',
                  onTap: model.onNextTapped
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
