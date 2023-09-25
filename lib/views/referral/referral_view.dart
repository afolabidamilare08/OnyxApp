import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/utils/custom_icons.dart';
import 'package:onyxswap/widgets/app_button.dart';

import '../../core/routes/routing_constants.dart';
import '../../utils/color.dart';
import '../../utils/text.dart';

class ReferAndEarn extends StatelessWidget {
  const ReferAndEarn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavigationService _navigationService = NavigationService.I;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: kSecondaryColor,
                    )),
                AppText.heading1L(
                  'Refer And Earn',
                  color: kSecondaryColor,
                ),
                const SizedBox(width: 40)
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset('assets/svgs/referbg.svg'),
                SvgPicture.asset('assets/svgs/referpage.svg')
              ],
            ),
            Column(
              children: [
                AppText.button2L(
                  'Get 20% commission',
                  color: kSecondaryColor,
                ),
                const SizedBox(
                  height: 32,
                ),
                AppText.button2L(
                  'Invite a friend and get 20% commision for fees every time they buy or sell using the app',
                  color: kSecondaryColor,
                  multitext: true,
                ),
                const SizedBox(
                  height: 32,
                ),
                Container(
                  height: 61,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: kBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 98,
                            child: AppText.button2L(
                              'Https:// web.xnyscard.com/auth/signup/dhsjhdsjghgshkgsg',
                              overflow: TextOverflow.ellipsis,
                              multitext: false,
                            )),
                        const Icon(
                          Nyxicons.paste,
                          color: kPrimaryColor,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                const AppButton(
                  title: 'Share',
                  backgroundColor: kPrimaryColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                  title: 'View Earnings',
                  backgroundColor: kPrimaryColor.withOpacity(0.32),
                  onTap: () => _navigationService
                      .navigateTo(NavigatorRoutes.refferalEarning),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
