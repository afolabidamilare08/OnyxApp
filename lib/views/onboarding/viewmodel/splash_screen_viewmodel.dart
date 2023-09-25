import 'package:flutter/material.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/widgets/base_view_model.dart';

class SplashScreenViewmodel extends BaseViewModel {
  final NavigationService _navigationService = NavigationService.I;
  final LocalCache localCache = locator<LocalCache>();
  checkLoginStatus() async {
    FocusScope.of(_navigationService.navigatorKey.currentContext!).unfocus();
    await Future.delayed(const Duration(seconds: 3));
  _navigationService.navigateTo(NavigatorRoutes.onboardingView);
    // String? token = localCache.getToken();
    // if (token == null) {
    //   _navigationService.navigateToReplace(NavigatorRoutes.onboardingView);
    // } else {
    //   localCache.getFromLocalCache('prices');
    //   localCache.getFromLocalCache('balances');
    //   print(localCache.getFromLocalCache('prices'));
    //   _navigationService.navigateToReplace(NavigatorRoutes.homeView);
    // }
  }
}
