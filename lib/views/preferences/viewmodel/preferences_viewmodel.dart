import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';

import '../../../models/exceptions.dart';
import '../../../models/failure.dart';
import '../../../utils/locator.dart';
import '../../../utils/network_client.dart';
import '../../../widgets/base_view_model.dart';
import '../../../widgets/flushbar.dart';

class PreferencesViewModel extends BaseViewModel {
  NetworkClient _networkClient = NetworkClient();
  LocalCache _localCache = locator<LocalCache>();
  NavigationService _navigationService = NavigationService.I;
  pushNotificationSetup(String token) async {
    String? userId = _localCache.getToken();
    try {
      await _networkClient.post('/insertToken',
          queryParameters: {'userid': userId, 'deviceToken': token});
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "connection Time out",
            "Please check your internet connection and try again",
          ));
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "No Internet connection",
            "Please check your internet connection and try again",
          ));
    } on Failure {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure:
              UserDefinedException('Something went wrong', 'Please try again'));
    }
  }

  bool isSwitched() {
    if (_localCache.getFromLocalCache('firebaseToken') != null) {
      // on = true;
      //notifyListeners();
      return true;
    } else {
      // on = false;
      //notifyListeners();
      return false;
    }
  }

  // PreferencesViewModel() {
  //   isSwitched();
  // }
}
