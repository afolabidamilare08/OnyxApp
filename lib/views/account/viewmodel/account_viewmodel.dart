import 'package:flutter/material.dart';

import '../../../core/constants/custom_icons.dart';
import '../../../core/routes/routing_constants.dart';
import '../../../core/services/navigation_service.dart';
import '../../../data/local/local_cache/local_cache.dart';
import '../../../utils/color.dart';
import '../../../utils/locator.dart';
import '../../../utils/text.dart';
import '../../../widgets/base_view_model.dart';

class AccountViewmodel extends BaseViewModel {
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  String? fullname;
  List<String> title = [
    'Verify Identity',
    'Bank',
    'Security',
    //'Preferences',
   // 'Refer and earn'
  ];
  List<String> subtitle = [
    'Complete Your account Verification',
    'Manage saved bank accounts',
    'Manage password, pin & two-factor-authentication',
    //'Manage notification & languages',
    //'Earn commision for refering Onyxswap to others'
  ];
  List<IconData> icons = [
    NyxIcons.account,
    NyxIcons.banks,
    NyxIcons.security,
    //NyxIcons.preferences,
   // NyxIcons.refer
  ];

  List routes = [
    NavigatorRoutes.kyc,
    NavigatorRoutes.addBank,
    NavigatorRoutes.security,
    //NavigatorRoutes.preferences,
    //NavigatorRoutes.refer
  ];
  getFullname() {
    fullname = _localCache.getFromLocalCache('firstname').toString();
  }

  logout() {
    showDialog(
      context: _navigationService.navigatorKey.currentContext!,
      builder: (context) => Dialog(
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.body1L(
                  'Are you sure you want to Sign out?',
                  color: kSecondaryColor,
                  centered: true,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _localCache.deleteToken();
                          _localCache.clearCache();
                          _navigationService.navigateAndRemoveUntil(
                              newRoute: NavigatorRoutes.onboardingView,
                              routeToLeave: '/');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: AppText.body3L(
                            'YES',
                            color: Colors.white,
                          ),
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8)),
                        )),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        alignment: Alignment.center,
                        child: AppText.body3L(
                          'No',
                          color: kPrimaryColor,
                        ),
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AccountViewmodel() {
    getFullname();
  }
}
