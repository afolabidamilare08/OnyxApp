import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/core/constants/routeargument_key.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/views/forget%20password/component/passwordsuccess.dart';
import 'package:onyxswap/views/forget%20password/component/reset_password.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/flushbar.dart';

import '../../../core/routes/routing_constants.dart';
import '../../../models/exceptions.dart';
import '../../../models/failure.dart';
import '../../../utils/custom_icons.dart';
import '../../../widgets/transaction_successful.dart';
import '../component/verify_otp.dart';

class ForgetPasswordViewmodel extends BaseViewModel {
  final NetworkClient _networkClient = NetworkClient();
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  List<IconData> icon = [Nyxicons.airtime];
  List<String> title = ['Via phone'];
  String? referenceid;
  //String? phonumber;
  GlobalKey<FormState> phoneformkey = GlobalKey<FormState>();
  GlobalKey<FormState> pinformkey = GlobalKey<FormState>();
  GlobalKey<FormState> resetformkey = GlobalKey<FormState>();
  Timer? timer;
  String? gottenphoneumber;
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else {
        timer.cancel();
      }
      notifyListeners();
    });
  }

  resetTimer() {
    seconds = maxSeconds;
    startTimer();
    notifyListeners();
  }

  onSendSMSTap(String phonenumber) async {
    if (phoneformkey.currentState!.validate()) {
      // String? userid = _localCache.getToken();
      try {
        isLoading = true;
        var result = await _networkClient.post(ApiRoutes.forgotpasswordauth,
            body: FormData.fromMap({'phonenumber': phonenumber}));
        // await _networkClient.post(ApiRoutes.sendAuthCode,
        //     body: FormData.fromMap(
        //         {'selectedMethod': 'verifyphonenumber', 'userId': userid}));
        gottenphoneumber = result['phonenumber'];
        Map<String, dynamic> response = _networkClient.data['otpresponse'];
        if (response.containsKey('error')) {
          OnyxFlushBar.showError(title: 'Error', message: response['error']);
          isLoading = false;
        } else {
          referenceid = response['entity'][0]['reference_id'];
          // phonumber = phonenumber;
          isLoading = false;
          print(referenceid);
          _navigationService.navigateTo(NavigatorRoutes.verifyOtp, argument: {
            RouteArgumentkeys.type: title[0],
            RouteArgumentkeys.referenceId: response['entity'][0]
                ['reference_id'],
            RouteArgumentkeys.phonenumber: phonenumber
          });
          // Navigator.push(
          //     _navigationService.navigatorKey.currentContext!,
          //     MaterialPageRoute(
          //         builder: (context) => VerifyPasswordOtp(
          //             type: title[0],
          //             referenceid: response['entity'][0]['reference_id'],
          //             phonenumber: phonenumber)));
        }
      } on InvalidCredentialException {
        OnyxFlushBar.showError(
            title: 'Error', message: 'User does not exist try Sign up');
        isLoading = false;
      } on InternalServerErrorException {
        OnyxFlushBar.showError(
            title: 'Something went wrong', message: 'Try again');
        isLoading = false;
      } on DeadlineExceededException {
        OnyxFlushBar.showError(
            title: 'Connection Time out', message: 'Please Try again');
        isLoading = false;
      }
    }
  }

  onVerifyTap(String pin, String reference, String phonenumber) async {
    try {
      print(referenceid);
      isLoading = true;
      await _networkClient.get(ApiRoutes.forgotpasswordauthverify,
          queryParameters: {'reference_id':referenceid?? reference});
      await _networkClient.post(ApiRoutes.forgotpasswordauthverify,
          body: FormData.fromMap({'verifycode': pin}));
      Map<String, dynamic> response = _networkClient.data['otpresponse'];
      if (response['entity']['valid'] == true) {
        isLoading = false;
        _navigationService.navigateTo(NavigatorRoutes.resetPassword,
            argument: {RouteArgumentkeys.phonenumber: phonenumber});
        // Navigator.push(
        //     _navigationService.navigatorKey.currentContext!,
        //     MaterialPageRoute(
        //         builder: (context) => ResetPassword(phonenumber: phonenumber)));
      } else {
        OnyxFlushBar.showError(title: 'Error', message: 'Wrong Otp');
        isLoading = false;
      }
    } on InvalidCredentialException {
      OnyxFlushBar.showError(title: 'Error', message: ' Error Verifying');
      isLoading = false;
    } on InternalServerErrorException {
      OnyxFlushBar.showError(
          title: 'Something went wrong', message: 'Try again');
      isLoading = false;
    } on DeadlineExceededException {
      OnyxFlushBar.showError(
          title: 'Connection Time out', message: 'Please Try again');
      isLoading = false;
    }
  }

  resetPassword(String password, String phonenumber) async {
    if (resetformkey.currentState!.validate()) {
      isLoading = true;
      //print(phonumber);
      try {
        await _networkClient.post(ApiRoutes.resetPassword,
            body: FormData.fromMap(
                {'phonenumber': phonenumber, 'password': password}));
        _navigationService
            .navigateTo(NavigatorRoutes.passwordSuccess, argument: {
          RouteArgumentkeys.heading: 'Password reset Successful',
          RouteArgumentkeys.subheading:
              'Your password reset was Successful.\n Press Continue to login',
          RouteArgumentkeys.onTap: () => Navigator.popUntil(
              _navigationService.navigatorKey.currentState!.context,
              ModalRoute.withName(
                NavigatorRoutes.loginView,
              ))
        });
        // Navigator.push(
        //     resetformkey.currentState!.context,
        //     MaterialPageRoute(
        //         builder: (context) => PasswordSuccess(
        //             heading: 'Password reset Successful',
        //             subHeading:
        //                 'Your password reset was Successful.\n Press Continue to login',
        //             onTap: () => Navigator.popUntil(
        //                 _navigationService.navigatorKey.currentState!.context,
        //                 ModalRoute.withName(
        //                   NavigatorRoutes.loginView,
        //                 )))));
      } on InvalidCredentialException {
        OnyxFlushBar.showError(
            title: 'Invalid password',
            message:
                'Password must contain capital letter,small letter a number and a symbol');
        isLoading = false;
      } on InternalServerErrorException {
        OnyxFlushBar.showError(
            title: 'Something went wrong', message: 'Try again');
        isLoading = false;
      } on DeadlineExceededException {
        OnyxFlushBar.showError(
            title: 'Connection Time out', message: 'Please Try again');
        isLoading = false;
      } on NoInternetConnectionException {
        OnyxFlushBar.showError(
            title: 'No internet connection', message: 'Try again');
        isLoading = false;
      }
    }
  }

  resendOtp(String phonenumber, BuildContext context) async {
    try {
      print(gottenphoneumber);
      var result = await _networkClient.post(
          ApiRoutes.forgotpasswordauthverifyresend,
          body: FormData.fromMap({'phonenumber': phonenumber}));
      referenceid = result['otpresponse']['entity'][0]['reference_id']??result['otpresponse']['entity']['reference_id'];
      OnyxFlushBar.showSuccess(
          context: context, message: 'Otp sent succesfully');
      resetTimer();
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "connection Time out",
            "Please check your internet connection and try again",
          ));
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "No Internet connection",
            "Please check your internet connection and try again",
          ));
    } on Failure {
      OnyxFlushBar.showFailure(
          context: context,
          failure:
              UserDefinedException('Something went wrong', 'Please try again'));
    }
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }

    super.dispose();
  }
}
