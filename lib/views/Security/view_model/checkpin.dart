import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/chatMessgaeModel.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/models/failure.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/flushbar.dart';

import '../../../core/routes/routing_constants.dart';
import '../../../core/services/navigation_service.dart';
import '../component/setup_pin.dart';
import '../component/update_password.dart';

class CheckPinViewmodel extends BaseViewModel {
  final NetworkClient _networkClient = NetworkClient();
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  bool pinCreated = false;
  List<String> title = [
    'Password',
    'Pin',
    'Two factor Authentication',
  ];
  List<String> subtitle = [
    'Update your Password',
    'Set transaction Pin',
    'Enable two factor authentication'
  ];

  checkPin() async {
    isLoading = true;
    String? userid = _localCache.getToken();
    try {
      await _networkClient.post(ApiRoutes.checkApppin,
          body: FormData.fromMap({'userId': userid}));
      Map<String, dynamic> result = _networkClient.data;
      if (result['status'] == 403) {
        pinCreated = true;
        notifyListeners();
      } else if (result['status'] == 200) {
        pinCreated = false;
        title.removeAt(1);
        subtitle.removeAt(1);
        notifyListeners();
      }
      isLoading = false;
    } on Failure catch (e) {
      OnyxFlushBar.showError(title: e.title, message: e.message);
      isLoading = false;
    }
  }

  onSecurityWidgetTapped(int index) async {
    if (index == 0) {
      Navigator.push(_navigationService.navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => UpdatePassword()));
    } else if (index == 1 && title[1] == 'Pin') {
      Navigator.push(
          _navigationService.navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => PinSetup(
                  heading: 'Setup Pin',
                  title: 'Pin',
                  subtitle: 'Confirm pin')));
    } else if (index == 1 && title[1] != 'Pin' || index == 2) {
      try {
        String? userid = _localCache.getToken();
        isLoading = true;
        var response = await _networkClient.post('/check2fa',
            body: FormData.fromMap({'userid': userid}));
        isLoading = false;
        OnyxFlushBar.showSuccess(
            context: _navigationService.navigatorKey.currentContext!,
            message: '2 factor authentication Set');
      } on InvalidCredentialException {
        isLoading = false;
        _navigationService.navigateTo(NavigatorRoutes.twoFactorAuthenticaton);
      } on Failure catch (e) {
        OnyxFlushBar.showError(title: e.title, message: e.message);
      }
    } else {
      () {};
    }
  }

  // List<String> miniTitle = title.removeAt(1);
  CheckPinViewmodel() {
    checkPin();
  }
}
