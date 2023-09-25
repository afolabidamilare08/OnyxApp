import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/views/kyc/component/successful.dart';
import 'package:onyxswap/widgets/base_view_model.dart';

import '../../../data/remote/auth/auth_interface.dart';
import '../../../data/remote/auth/auth_service.dart';
import '../../../utils/locator.dart';
import '../../../widgets/flushbar.dart';
import '../../../widgets/transaction_successful.dart';

class SetupPinViewModel extends BaseViewModel {
  final AuthService _authService = AuthServiceimpl();

  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final NavigationService _navigationService = NavigationService.I;
  final LocalCache _localCache = locator<LocalCache>();
  final NetworkClient _networkClient = NetworkClient();
  bool selected = false;
  createPin(String pin) async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading = true;
        String? userid = _localCache.getToken();
        print(userid);
        await _authService.createPin(pin: pin, userid: userid);
        isLoading = false;
        Navigator.push(
            formKey.currentContext!,
            MaterialPageRoute(
                builder: ((BuildContext context) => TransactionSuccessful(
                      heading: 'Pin successfully created',
                      subHeading: '',
                    ))));
      } on ServerCommunicationException {
        OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Failed",
            "Error ocurred while creating pin",
          ),
        );

        isLoading = false;
      } on InternalServerErrorException {
        OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Failed",
            "Error ocurred while creating pin",
          ),
        );

        isLoading = false;
      }
    } else {
      print('error');
    }
  }

  resetPassword(String? password, BuildContext context) async {
    String? userid = _localCache.getToken();
    isLoading = true;
    try {
      await _networkClient.post(ApiRoutes.resetPassword,
          body: FormData.fromMap(
              {'password': password, 'userId': userid, 'phonenumber': ''}));
      isLoading = false;
      Map<String, dynamic> result = _networkClient.data;
      if (result['status'] == 200) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Successful(title: 'Password Reset successfully')));
      } else {
        OnyxFlushBar.showFailure(
            context: context,
            failure: UserDefinedException(
                'Error', '${result['error']} Please follow the requirement'));
        isLoading = false;
      }
    } on ServerCommunicationException {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "Error",
          "Something Went wrong",
        ),
      );

      isLoading = false;
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "Error",
          "Something Went wrong",
        ),
      );

      isLoading = false;
    } on InvalidCredentialException {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "Error",
          "No user with this account details",
        ),
      );
    }
  }
}
