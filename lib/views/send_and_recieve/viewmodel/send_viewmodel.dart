import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/push_notification_model.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/views/send_and_recieve/components/sendotp.dart';
import 'package:onyxswap/views/send_and_recieve/models/sendmodel.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/pin_bottomsheet.dart';
import 'package:onyxswap/widgets/transaction_successful.dart';

import '../../../core/constants/routeargument_key.dart';
import '../../../core/constants/textstyle.dart';
import '../../../core/routes/routing_constants.dart';
import '../../../models/exceptions.dart';
import '../../../models/failure.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../../../widgets/flushbar.dart';
import '../../../widgets/two_factor_widget.dart';
//import '../../buy_and_sell/components/pinotp.dart';

class SendAndRecieveViewmodel extends BaseViewModel {
  final NetworkClient _networkClient = NetworkClient();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> twoFAFormKey = GlobalKey<FormState>();
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  bool haserror = false;
  bool isSending = false;
  List<String> assets = ['BTC', 'USDT', 'BUSD'];
  List option = [
    {'item': 'BTC', 'value': 'BTC'},
    {'item': 'USDT', 'value': 'USDT_TRON'},
    {'item': 'BUSD', 'value': 'BUSD'},
  ];
  String? referenceid;
  String selected = 'BTC';
  String address = '';
  String? charges;
  String? marketprice;
  String? assetPrice;
  String? usdPrice;
  String? asset;
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;
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

  onTap(String selected, BuildContext context) async {
    String? userid = _localCache.getToken();
    print(userid);
    try {
      await _networkClient.post(ApiRoutes.recieve,
          body: FormData.fromMap({'userid': userid, 'asset': selected}));
      Map<String, dynamic> result = _networkClient.data;
      if (result.containsKey('error')) {
        Navigator.pop(context);
        OnyxFlushBar.showFailure(
            context: _navigationService.navigatorKey.currentContext!,
            failure: UserDefinedException(
              'Error',
              result['error'],
            ));
        isLoading = false;
      }
      address = result['address'];
      notifyListeners();
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Something Went wrong",
            "Please try again",
          ));
      isLoading = false;
    } on InvalidCredentialException {
      Navigator.pop(_navigationService.navigatorKey.currentContext!);
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            'Error',
            'Error fetching Address',
          ));
      isLoading = false;
    } on DeadlineExceededException {
      Navigator.pop(_navigationService.navigatorKey.currentContext!);
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "connection Time out",
            "Please check your internet connection and try again",
          ));
      isLoading = false;
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "No Internet connection",
            "Please check your internet connection and try again",
          ));
    }
  }

  getMarketValue() async {
    try {
      isLoading = true;
      String? userid = _localCache.getToken();
      await _networkClient.post(ApiRoutes.buy,
          body: FormData.fromMap({
            'user': userid,
            'assetType': asset,
          }));
      Map<String, dynamic> result = _networkClient.data;

      if (result['status'] == 200) {
        marketprice = result['assetmarketPrice'];
        // buyrate = result['assetdata'][0][3];
        charges = result['assetdata'][2][5];
        // sellcharges = result['assetdata'][1][4];
        // sellrate = result['assetdata'][1][3];
        if (!isDisposed) {
          notifyListeners();
        }

        isLoading = false;
      } else {
        Navigator.pop(_navigationService.navigatorKey.currentContext!);
        OnyxFlushBar.showFailure(
            context: formKey.currentContext!,
            failure: UserDefinedException(
                'Error', "Couldn't load current market value"));
      }
      isLoading = false;
      if (!isDisposed) {
        notifyListeners();
      }
    } on Failure catch (e) {
      Navigator.pop(_navigationService.navigatorKey.currentContext!);
      OnyxFlushBar.showError(title: e.title, message: e.message);
      isLoading = false;
    }
    isLoading = false;
  }

  onPinTap(
      {required String pin,
      required String userid,
      required String amount,
      required String reciever,
      required String referenceids,
      required String type,
      required bool mounted,
      required BuildContext context}) async {
    try {
      isLoading = true;
      print(referenceid);
      await _networkClient.get(ApiRoutes.verifyAuthCode, queryParameters: {
        'selectedMethod': 'verifyphonenumber',
        'reference_id': referenceid ?? referenceids
      });
      await _networkClient.post(ApiRoutes.verifyAuthCode,
          body: FormData.fromMap({'verifycode': pin}));
      Map<String, dynamic> result = _networkClient.data['otpresponse'];
      if (result.containsKey('error')) {
        OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "Error",
            "${result['error']}",
          ),
        );
        timer!.cancel();
        isLoading = false;
      } else {
        if (_networkClient.data['otpresponse']['entity']['valid'] == true) {
          Map<String, dynamic> response;

          await sendCryto(
              reciever: reciever, amount: amount, context: context, type: type);
        } else {
          OnyxFlushBar.showFailure(
            context: _navigationService.navigatorKey.currentContext!,
            failure: UserDefinedException(
              "Wrong OTP",
              "You have entered the wrong OTP",
            ),
          );
          timer!.cancel();
          isLoading = false;
        }
      }
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "ERROR",
          "Something went wrong try again",
        ),
      );
      timer!.cancel();
      isLoading = false;
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "No Internet Connection",
          "Connect to the internet and try again",
        ),
      );
      timer!.cancel();
      if (mounted) {
        startTimer();
      }
      isLoading = false;
    }
  }

  Future resendCode(BuildContext context) async {
    String? userid = _localCache.getToken();
    try {
      var result = await _networkClient.post(ApiRoutes.resendverifyAuthCode,
          body: FormData.fromMap({'userid': userid}));
      referenceid = result['otpresponse']['entity'][0]['reference_id'] ??
          result['otpresponse']['entity']['reference_id'];
      print('checked');
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

  toggleHaserror() {
    haserror = true;
    notifyListeners();
  }

  sendCryto(
      {required String reciever,
      required String amount,
      required String type,
      required BuildContext context}) async {
    try {
      String? userid = _localCache.getToken();
      Map<String, dynamic> result = await _networkClient.post(ApiRoutes.send,
          body: FormData.fromMap({
            'reciveraddress': reciever,
            'userid': userid,
            'assetType': type,
            'amount': amount
          }));
      print('hola');
      SendModel response = SendModel.fromJson(result);
      // var result = _networkClient.data;
      if (result.containsKey('error')) {
        OnyxFlushBar.showFailure(
            context: formKey.currentContext!,
            failure: UserDefinedException(
              "Error",
              _networkClient.data['error'],
            ));
        print('hola error');
        isSending = false;
        isLoading = false;
      } else {
        // if (response.status != 'success') {
        //   OnyxFlushBar.showFailure(
        //       context: formKey.currentContext ??
        //           _navigationService.navigatorKey.currentContext!,
        //       failure: UserDefinedException(
        //         "Error",
        //         'Error could not send',
        //       ));
        //   isSending = false;
        //   isLoading = false;
        // }
        // else {
        Navigator.push(
            formKey.currentContext ??
                _navigationService.navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => TransactionSuccessful(
                    heading: 'Your Transaction is successfull',
                    subHeading: response.data
                    // response.data.status == 'PENDING'
                    //     ? 'You will be Notified when your transaction is completed'
                    //     : response.data.status == 'SUCCESS'
                    //         ? 'You have successfully transferred $amount ${type.toLowerCase()} to $reciever address'
                    //         : 'Your transaction has failed '
                    )));
        LocalNotification.showNotification(
            title: 'Transaction Successful',
            body:
                'You have successfully transferred $amount ${type.toLowerCase()} to $reciever address');
        // }
      }
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: formKey.currentContext ??
              _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Something Went wrong",
            "Please try again",
          ));
      isLoading = false;
      isSending = false;
    } on InvalidCredentialException {
      OnyxFlushBar.showFailure(
          context: formKey.currentContext ??
              _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Insuffient funds",
            " Unable to send $type balance insufficient",
          ));
      // Navigator.pop(context);
      isLoading = false;
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "No Internet connection",
            "Please check your internet connection and try again",
          ));
      isLoading = false;
    } on Failure {
      OnyxFlushBar.showFailure(
          context: context,
          failure:
              UserDefinedException('Something went wrong', 'Please try again'));
      isLoading = false;
    }
  }

  twoFA(
      {required TextEditingController twoFA,
      required String amount,
      required String reciever,
      required BuildContext context,
      required TextEditingController pin,
      required String type}) async {
    if (formKey.currentState!.validate()) {
      if (asset == null) {
        //model.toggleHaserror();
        haserror = true;
        notifyListeners();
      } else {
        isLoading = true;
        try {
          isLoading = true;
          String? userid = _localCache.getToken();
          var response = await _networkClient.post('/check2fa',
              body: FormData.fromMap({'userid': userid}));
          isLoading = false;
          if (response['status'] == 200) {
            showModalBottomSheet(
                context: _navigationService.navigatorKey.currentContext!,
                enableDrag: false,
                //isDismissible: false,
                isScrollControlled: true,
                backgroundColor: AppColors.backgroundColor,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                builder: (context) => TwoFactorBottomSheet(
                    onTap: () async {
                      if (twoFAFormKey.currentState!.validate()) {
                        Navigator.pop(context);
                        try {
                          isLoading = true;
                          var response = await _networkClient.post('/verify2fa',
                              body: FormData.fromMap(
                                  {'userid': userid, 'twofacode': twoFA.text}));
                          isLoading = false;
                          onSendTap(
                              amount: amount,
                              reciever: reciever,
                              context: context,
                              pin: pin,
                              type: type);
                               twoFA.clear();
                        } on InvalidCredentialException {
                          OnyxFlushBar.showError(
                              message: 'Invalid code', title: 'Error');
                          isLoading = false;
                        } on Failure catch (e) {
                          OnyxFlushBar.showError(
                              message: e.message, title: e.title);
                          isLoading = false;
                        }
                      }
                    },
                    controller: twoFA,
                    formKey: twoFAFormKey));
            isLoading = false;
          } else if (response['status'] == 403) {
            onSendTap(
                amount: amount,
                reciever: reciever,
                context: context,
                pin: pin,
                type: type);
            isLoading = false;
          }
        } on InvalidCredentialException {
          onSendTap(
              amount: amount,
              reciever: reciever,
              context: context,
              pin: pin,
              type: type);
          isLoading = false;
        } on Failure catch (e) {
          OnyxFlushBar.showError(title: e.title, message: e.message);
          isLoading = false;
        }
      }
    }
  }

  onSendTap(
      {required String amount,
      required String reciever,
      required BuildContext context,
      required TextEditingController pin,
      required String type}) async {
    String? userid = _localCache.getToken();

    await _networkClient.post(ApiRoutes.checkApppin,
        body: FormData.fromMap({'userId': userid}));
    Map<String, dynamic> result = _networkClient.data;
    if (result['status'] == 403) {
      _navigationService.navigateTo(NavigatorRoutes.pinSetup, argument: {
        RouteArgumentkeys.heading: 'Create Transaction pin',
        RouteArgumentkeys.subheading: 'Confirm pin',
        RouteArgumentkeys.title: 'pin'
      });
      isLoading = false;
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => PinSetup(
      //             heading: 'Create Transaction pin',
      //             title: 'pin',
      //             subtitle: 'Confirm pin')));
    } else if (result['status'] == 200) {
      isLoading = false;
      showModalBottomSheet(
          context: _navigationService.navigatorKey.currentContext!,
          enableDrag: false,
          //isDismissible: false,
          isScrollControlled: true,
          backgroundColor: AppColors.backgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (context) => PinBottomSheet(
                amount: amount,
                controller: pin,
                isloading: isLoading,
                onCompleted: (value) async {
                  Navigator.pop(context);
                  try {
                    isLoading = true;
                    await _networkClient.post(ApiRoutes.checkpin,
                        body: FormData.fromMap({
                          'userId': userid,
                          'checkPin': 1,
                          'appPinVal': pin.text
                        }));
                    sendCryto(
                        reciever: reciever,
                        amount: amount,
                        type: type,
                        context: context);
                    isLoading = false;
                  } on InvalidCredentialException {
                    // Navigator.pop(context);
                    OnyxFlushBar.showFailure(
                      context: _navigationService.navigatorKey.currentContext!,
                      failure: UserDefinedException(
                        "Pin  Incorrect",
                        "Incorrect Pin",
                      ),
                    );

                    //pin.dispose();
                    isLoading = false;
                  } on InternalServerErrorException {
                    OnyxFlushBar.showFailure(
                        context:
                            _navigationService.navigatorKey.currentContext!,
                        failure: UserDefinedException(
                          "Something Went wrong",
                          "Please try again",
                        ));
                    isLoading = false;
                    //   Navigator.pop(context);
                    //notifyListeners();
                  } on DeadlineExceededException {
                    OnyxFlushBar.showFailure(
                        context: context,
                        failure: UserDefinedException(
                          "connection Time out",
                          "Please check your internet connection and try again",
                        ));
                    isLoading = false;
                  }
                },
              ));
    }
    // amount();
    // reciever.clear();
    //   String? userid = _localCache.getToken();
    //   isSending = true;
    //   isLoading = true;
    //   notifyListeners();
    //   try {
    //     await _networkClient.get(ApiRoutes.sendAuthCode, queryParameters: {
    //       //'assetamount': assetamount,
    //       'asset': asset,
    //       'amount': amount,
    //       //'usdprice': usdprice,
    //     });
    //     await _networkClient.post(ApiRoutes.sendAuthCode,
    //         body: FormData.fromMap(
    //             {'selectedMethod': 'verifyphonenumber', 'userId': userid}));
    //     Map<String, dynamic> data = _networkClient.data['otpresponse'];
    //     if (data.containsKey('error')) {
    //       OnyxFlushBar.showFailure(
    //         context: context,
    //         failure: UserDefinedException(
    //           "Error",
    //           "${data['error']}",
    //         ),
    //       );
    //       isLoading = false;
    //     } else {
    //       if (data['entity'][0]['status'] == 'sms OTP sent successfully') {
    //         print(data['entity'][0]['status']);
    //         OnyxFlushBar.showFailure(
    //           context: context,
    //           failure: UserDefinedException(
    //             "Error",
    //             "${data['entity'][0]['status']}",
    //           ),
    //         );
    //         isLoading = false;
    //       }
    //       // else if (data['entity']['status'] != 'Sent') {
    //       //   OnyxFlushBar.showFailure(
    //       //     context: _navigationService.navigatorKey.currentContext!,
    //       //     failure: UserDefinedException(
    //       //       "Error",
    //       //       "${data['entity'][0]['status']}",
    //       //     ),
    //       //   );
    //       // }
    //       else {
    //         referenceid = data['entity'][0]['reference_id'];
    //         await _networkClient
    //             .get(ApiRoutes.verifyAuthCode, queryParameters: {
    //           //  'assetamount': assetamount,
    //           'asset': asset,
    //           'amount': amount,
    //           //'usdprice': usdprice,
    //           'selectedMethod': 'verifyphonenumber',
    //           'reference_id': data['entity'][0]['reference_id'],
    //         });
    //         //referenceid = data['entity'][0]['reference_id'];
    //         Navigator.push(
    //             _navigationService.navigatorKey.currentState!.context,
    //             MaterialPageRoute(
    //                 builder: (context) => PinOtp(
    //                     amount: amount,
    //                     referenceid: referenceid,
    //                     userid: userid,
    //                     reciever: reciever,
    //                     type: asset!)));
    //       }
    //     }
    //   } on DeadlineExceededException {
    //     OnyxFlushBar.showFailure(
    //         context: context,
    //         failure: UserDefinedException(
    //           "connection Time out",
    //           "Please check your internet connection and try again",
    //         ));
    //     isLoading = false;
    //   } on NoInternetConnectionException {
    //     OnyxFlushBar.showFailure(
    //         context: context,
    //         failure: UserDefinedException(
    //           "No Internet connection",
    //           "Please check your internet connection and try again",
    //         ));
    //     isLoading = false;
    //   } on Failure {
    //     OnyxFlushBar.showFailure(
    //         context: context,
    //         failure: UserDefinedException(
    //             'Something went wrong', 'Please try again'));
    //     isLoading = false;
    //   }
  }

  buildDropdown(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: false,
        child: DropdownButton2<String>(
            dropdownWidth: MediaQuery.of(context).size.width,
            dropdownFullScreen: false,
            isExpanded: true,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kPrimaryColor,
            ),
            offset: const Offset(-10, -20),
            value: asset,
            iconSize: 30,
            style: body3L.copyWith(color: kSecondaryColor),
            hint: AppText.body3L('Asset'),
            onChanged: (value) => onChanged(value!),
            items: option
                .map((item) => buildMenuItem(item['item'], item['value']))
                .toList()),
      ),
    );
  }

  getBalance() async {
    print('balance');
    String? userid = await _localCache.getToken();
    try {
      await getMarketValue();
      var result = await _networkClient.post(ApiRoutes.checkassetbalance,
          body: FormData.fromMap({'userid': userid, 'asset': asset}));
      assetPrice = result['balance'].toString();
      usdPrice = (double.parse(assetPrice!) * double.parse(marketprice!))
          .toStringAsFixed(3);
      if (!isDisposed) {
        notifyListeners();
      }
      isLoading = false;
    } on InternalServerErrorException {
      _localCache.getFromLocalCache('balances');
      if (!isDisposed) {
        notifyListeners();
      }
      // OnyxFlushBar.showFailure(
      //     context: scaffoldKey.currentState!.context,
      //     failure: UserDefinedException(
      //         'No internet connection', 'Prices are not updated'));
      isLoading = false;
    } on DeadlineExceededException {
      _localCache.getFromLocalCache('balances');
      if (!isDisposed) {
        notifyListeners();
      }
      isLoading = false;
    } on Failure {
      // OnyxFlushBar.showFailure(
      //     context: scaffoldKey.currentState!.context,
      //     failure: UserDefinedException(
      //         'No internet connection', 'Prices are not updated'));
      _localCache.getFromLocalCache('balances');
      if (!isDisposed) {
        notifyListeners();
      }
      isLoading = false;
    } on DioError {
      _localCache.getFromLocalCache('balances');
    }
  }

  onChanged(String e) {
    asset = e;
    print(asset!.split('_')[0]);
    getBalance();
    notifyListeners();
  }

  DropdownMenuItem<String> buildMenuItem(String item, String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: AppText.body1L(
        item,
        color: kSecondaryColor,
      ),
    );
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
  }
}
