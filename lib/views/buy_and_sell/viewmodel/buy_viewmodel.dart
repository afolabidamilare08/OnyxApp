import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/core/constants/routeargument_key.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/models/push_notification_model.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/views/buy_and_sell/components/pinotp.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/flushbar.dart';
import 'package:onyxswap/widgets/pin_bottomsheet.dart';
import 'package:onyxswap/widgets/transaction_successful.dart';
import 'package:onyxswap/widgets/two_factor_widget.dart';

import '../../../core/constants/textstyle.dart';
import '../../../core/services/navigation_service.dart';
import '../../../models/failure.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text.dart';

class BuyViewModel extends BaseViewModel {
  final NetworkClient _networkClient = NetworkClient();
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> twFAformkey = GlobalKey<FormState>();
  late Timer buytimer;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String? marketprice;
  String? buyrate;
  String? buycharges;
  String? sellcharges;
  String? sellrate;
  String? nairabalance;
  String btnText = 'Sell';
  String? referenceid;
  List<String> assets = ['BTC', 'USDT', 'BUSD'];
  List<String> assetsmod = ['BTC', 'USDT_TRON', 'BUSD'];
  String asset = 'BTC';
  String assetprice = 'BTC';
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;
  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

  buildDropDown({
    required BuildContext context,
    required String type,
    required TextEditingController ngnController,
    required TextEditingController usdController,
    required TextEditingController assetController,
    //void Function(String?)? onChanged,
  }) {
    return ButtonTheme(
      alignedDropdown: false,
      child: DropdownButton2<String>(
          // underline: const Padding(
          //   padding: EdgeInsets.only(top: 5),
          //   child: Divider(color: kSecondaryColor),
          // ),
          isExpanded: true,
          dropdownWidth: MediaQuery.of(context).size.width - 40,
          dropdownFullScreen: false,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kPrimaryColor,
          ),
          offset: const Offset(-10, -20),
          value: asset,
          iconSize: 30,
          style: body3L.copyWith(color: Colors.white),
          // hint: AppText.body3L(
          //   hint ?? '',
          //   color: kSecondaryColor,
          // ),
          onChanged: (e) => onChanged(
              e: e!,
              type: type,
              ngnController: ngnController,
              usdController: usdController,
              assetController: assetController),
          items:
              assetsmod.map((e) => buildMenuItem(e.split('_')[0], e)).toList()),
    );
  }

  onChanged({
    required String e,
    required String type,
    required TextEditingController ngnController,
    required TextEditingController usdController,
    required TextEditingController assetController,
  }) {
    asset = e;
    getMarketValue();
    getAssetBalance();
    ngnController.clear();
    usdController.clear();
    assetController.clear();
    notifyListeners();
  }

  DropdownMenuItem<String> buildMenuItem(String item, String value) {
    return DropdownMenuItem<String>(
      child: AppText.body1L(
        item,
        color: kSecondaryColor,
      ),
      value: value,
    );
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
        buyrate = result['assetdata'][0][3];
        buycharges = result['assetdata'][0][4];
        sellcharges = result['assetdata'][1][4];
        sellrate = result['assetdata'][1][3];
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

  getAssetBalance() async {
    print('balance');
    String? userid = await _localCache.getToken();
    try {
      // await getMarketValue();
      var result = await _networkClient.post(ApiRoutes.checkassetbalance,
          body: FormData.fromMap({'userid': userid, 'asset': asset}));
      assetprice = result['balance'].toString();
      // usdPrice = (double.parse(assetPrice!) * double.parse(marketprice!))
      //     .toStringAsFixed(3);
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

  twoFA(
      {required TextEditingController twoFA,
      required String assetamount,
      required String amount,
      required String usdprice,
      required String currentAsset,
      required TextEditingController pin,
      required String type}) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;

      try {
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
                    if (twFAformkey.currentState!.validate()) {
                      Navigator.pop(context);

                      try {
                        isLoading = true;
                        var response = await _networkClient.post('/verify2fa',
                            body: FormData.fromMap(
                                {'userid': userid, 'twofacode': twoFA.text}));
                        isLoading = false;
                        onTap(
                            amount: amount,
                            assetamount: assetamount,
                            usdprice: usdprice,
                            currentAsset: currentAsset,
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
                  formKey: twFAformkey));
        } else if (response['status'] == 403) {
          onTap(
              amount: amount,
              assetamount: assetamount,
              usdprice: usdprice,
              currentAsset: currentAsset,
              pin: pin,
              type: type);
        }
      } on InvalidCredentialException {
        onTap(
            amount: amount,
            assetamount: assetamount,
            usdprice: usdprice,
            currentAsset: currentAsset,
            pin: pin,
            type: type);
      } on Failure catch (e) {
        OnyxFlushBar.showError(title: e.title, message: e.message);
        isLoading = false;
      }
    }
  }

  onTap(
      {required String assetamount,
      required String amount,
      required String usdprice,
      required String currentAsset,
      required TextEditingController pin,
      required String type}) async {
    bool isSending = false;

    String? userid = _localCache.getToken();
    isLoading = true;

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
      showModalBottomSheet(
          context: _navigationService.navigatorKey.currentState!.context,
          enableDrag: false,
          isDismissible: false,
          isScrollControlled: true,
          backgroundColor: AppColors.backgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (context) => PinBottomSheet(
                amount: amount,
                controller: pin,
                isloading: isLoading,
                onCompleted: (pin) async {
                  Navigator.pop(context);
                  try {
                    isLoading = true;
                    await _networkClient.post(ApiRoutes.checkpin,
                        body: FormData.fromMap({
                          'userId': userid,
                          'checkPin': 1,
                          'appPinVal': pin
                        }));
                    try {
                      isLoading = true;
                      await _networkClient.get(
                          type == 'buy'
                              ? ApiRoutes.finalpay
                              : ApiRoutes.finalsell,
                          queryParameters: {
                            'userid': userid,
                            'amount': amount,
                            'assetamount': assetamount,
                            'asset': currentAsset,
                          });
                      //response = _networkClient.data;
                      // if (timer!.isActive) {
                      //   timer!.cancel();
                      // }
                      isLoading = false;
                      Navigator.push(
                          _navigationService.navigatorKey.currentContext!,
                          MaterialPageRoute(
                              builder: (context) => TransactionSuccessful(
                                  heading: 'Transaction Succesfull',
                                  subHeading:
                                      'You have successfully ${type == 'buy' ? 'bought' : 'sold'}$assetamount $currentAsset')));
                      // LocalNotification.showNotification(title: 'You $type')
                    } on InvalidCredentialException {
                      OnyxFlushBar.showFailure(
                        context:
                            _navigationService.navigatorKey.currentContext!,
                        failure: UserDefinedException(
                          'TRANSACTION FAILED',
                          type == 'buy'
                              ? 'Wallet has insufficient balance'
                              : 'Unable to sell Wallet Insufficient amount',
                        ),
                      );

                      // Navigator.pop(
                      //     _navigationService.navigatorKey.currentContext!);
                      // isLoading = false;
                      //Navigator.pop(_navigationService.navigatorKey.currentContext!);
                    } on Failure catch (e) {
                      OnyxFlushBar.showError(
                          title: e.title, message: e.message);
                    }
                    isLoading = false;
                    if (_networkClient.data ==
                        'Wallet has insufficient balance') {
                      OnyxFlushBar.showFailure(
                        context:
                            _navigationService.navigatorKey.currentContext!,
                        failure: UserDefinedException(
                          "Insufficient balance",
                          "Naira wallet has insuffient balance please make a deposit",
                        ),
                      );
                    }

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

                    isLoading = false;
                  } on Failure catch (e) {
                    OnyxFlushBar.showError(title: e.title, message: e.message);
                  }
                  isLoading = false;
                },
              ));
    }
    // isSending = true;
    // isLoading = true;
    // notifyListeners();
    // await _networkClient.get(ApiRoutes.sendAuthCode, queryParameters: {
    //   'assetamount': assetamount,
    //   'asset': asset,
    //   'amount': amount,
    //   'usdprice': usdprice,
    // });
    // await _networkClient.post(ApiRoutes.sendAuthCode,
    //     body: FormData.fromMap(
    //         {'selectedMethod': 'verifyphonenumber', 'userId': userid}));
    // Map<String, dynamic> data = _networkClient.data['otpresponse'];
    // if (data.containsKey('error')) {
    //   OnyxFlushBar.showFailure(
    //     context: _navigationService.navigatorKey.currentContext!,
    //     failure: UserDefinedException(
    //       "Error",
    //       "${data['error']}",
    //     ),
    //   );
    // } else {
    //   if (data['entity'][0]['status'] == 'sms OTP sent successfully') {
    //     print(data['entity'][0]['status']);
    //     OnyxFlushBar.showFailure(
    //       context: _navigationService.navigatorKey.currentContext!,
    //       failure: UserDefinedException(
    //         "Error",
    //         "${data['entity'][0]['status']}",
    //       ),
    //     );
    //   }
    //   // else if (data['entity']['status'] != 'Sent') {
    //   //   OnyxFlushBar.showFailure(
    //   //     context: _navigationService.navigatorKey.currentContext!,
    //   //     failure: UserDefinedException(
    //   //       "Error",
    //   //       "${data['entity'][0]['status']}",
    //   //     ),
    //   //   );
    //   // }
    //   else {
    //     referenceid = data['entity'][0]['reference_id'];
    //     await _networkClient
    //         .get(ApiRoutes.verifyAuthCode, queryParameters: {
    //       'assetamount': assetamount,
    //       'asset': asset,
    //       'amount': amount,
    //       'usdprice': usdprice,
    //       'selectedMethod': 'verifyphonenumber',
    //       'reference_id': data['entity'][0]['reference_id'],
    //     });
    //     //referenceid = data['entity'][0]['reference_id'];
    //     _navigationService.navigateTo(NavigatorRoutes.pinOtp, argument: {
    //       RouteArgumentkeys.amount: amount,
    //       RouteArgumentkeys.assetamount: assetamount,
    //       RouteArgumentkeys.userid: userid,
    //       RouteArgumentkeys.type: type,
    //       RouteArgumentkeys.asset: currentAsset,
    //       RouteArgumentkeys.referenceId: data['entity'][0]['reference_id']
    //     });
    //     if (timer != null) {
    //       timer!.cancel();
    //     }
    //     // Navigator.push(
    //     //     _navigationService.navigatorKey.currentContext!,
    //     //     MaterialPageRoute(
    //     //         builder: (context) => PinOtp(
    //     //             amount: amount,
    //     //             assetamount: assetamount,
    //     //             userid: userid!,
    //     //             type: type,
    //     //             referenceid: data['entity'][0]['reference_id'])));
    //     if (timer != null) {
    //       timer!.cancel();
    //     }
    //   }
    // }
    isSending = false;
    isLoading = false;
    notifyListeners();
  }

  getBalance() {
    nairabalance = _localCache.getFromLocalCache('nairabalance').toString();
  }

  // onPinTap(
  //     {required String pin,
  //     required String userid,
  //     required String amount,
  //     required String type,
  //     required String assetAmount,
  //     required String referenceids,
  //     required String currentAsset,
  //     required bool mounted}) async {
  //   try {
  //     isLoading = true;
  //     print(referenceid);
  //     await _networkClient.get(ApiRoutes.verifyAuthCode, queryParameters: {
  //       'selectedMethod': 'verifyphonenumber',
  //       'reference_id': referenceid ?? referenceids
  //     });
  //     await _networkClient.post(ApiRoutes.verifyAuthCode,
  //         body: FormData.fromMap({'verifycode': pin}));
  //     Map<String, dynamic> result = _networkClient.data['otpresponse'];
  //     if (result.containsKey('error')) {
  //       OnyxFlushBar.showFailure(
  //         context: _navigationService.navigatorKey.currentContext!,
  //         failure: UserDefinedException(
  //           "Error",
  //           "${result['error']}",
  //         ),
  //       );
  //       timer!.cancel();
  //       isLoading = false;
  //     } else {
  //       if (_networkClient.data['otpresponse']['entity']['valid'] == true) {
  //         Map<String, dynamic> response;
  //         try {
  //           await _networkClient.get(
  //               type == 'buy' ? ApiRoutes.finalpay : ApiRoutes.finalsell,
  //               queryParameters: {
  //                 'userid': userid,
  //                 'amount': amount,
  //                 'assetamount': assetAmount,
  //                 'asset': currentAsset,
  //               });
  //           response = _networkClient.data;
  //           if (timer!.isActive) {
  //             timer!.cancel();
  //           }
  //           isLoading = false;
  //           Navigator.push(
  //               _navigationService.navigatorKey.currentContext!,
  //               MaterialPageRoute(
  //                   builder: (context) => TransactionSuccessful(
  //                       heading: 'Transaction Succesfull', subHeading: '')));
  //         // LocalNotification.showNotification(title: 'You $type')
  //         } on InvalidCredentialException {
  //           OnyxFlushBar.showFailure(
  //             context: _navigationService.navigatorKey.currentContext!,
  //             failure: UserDefinedException(
  //               'TRANSACTION FAILED',
  //               type == 'buy'
  //                   ? 'Wallet has insufficient balance'
  //                   : 'Unable to sell Wallet Insufficient amount',
  //             ),
  //           );
  //           timer!.cancel();
  //           Navigator.pop(_navigationService.navigatorKey.currentContext!);
  //           isLoading = false;
  //           //Navigator.pop(_navigationService.navigatorKey.currentContext!);
  //         } on DeadlineExceededException {
  //           OnyxFlushBar.showFailure(
  //             context: _navigationService.navigatorKey.currentContext!,
  //             failure: UserDefinedException(
  //               "Connection Time out",
  //               "Please try again",
  //             ),
  //           );
  //           isLoading = false;
  //         }
  //         if (_networkClient.data == 'Wallet has insufficient balance') {
  //           OnyxFlushBar.showFailure(
  //             context: _navigationService.navigatorKey.currentContext!,
  //             failure: UserDefinedException(
  //               "Insufficient balance",
  //               "Naira wallet has insuffient balance please make a deposit",
  //             ),
  //           );
  //         }
  //         timer!.cancel();
  //         isLoading = false;
  //       } else {
  //         OnyxFlushBar.showFailure(
  //           context: _navigationService.navigatorKey.currentContext!,
  //           failure: UserDefinedException(
  //             "Wrong OTP",
  //             "You have entered the wrong OTP",
  //           ),
  //         );
  //         //timer!.cancel();
  //         isLoading = false;
  //       }
  //     }
  //   } on InternalServerErrorException {
  //     OnyxFlushBar.showFailure(
  //       context: _navigationService.navigatorKey.currentContext!,
  //       failure: UserDefinedException(
  //         "ERROR",
  //         "Something went wrong try again",
  //       ),
  //     );
  //     //timer!.cancel();
  //     isLoading = false;
  //   } on NoInternetConnectionException {
  //     OnyxFlushBar.showFailure(
  //       context: _navigationService.navigatorKey.currentContext!,
  //       failure: UserDefinedException(
  //         "No Internet Connection",
  //         "Connect to the internet and try again",
  //       ),
  //     );
  //     // timer!.cancel();
  //     if (!isDisposed) {
  //       startTimer();
  //     }
  //     isLoading = false;
  //   }
  // }

  // Future resendCode(BuildContext context) async {
  //   String? userid = _localCache.getToken();
  //   try {
  //     var result = await _networkClient.post(ApiRoutes.resendverifyAuthCode,
  //         body: FormData.fromMap({'userid': userid}));
  //     print('checked');
  //     referenceid = result['otpresponse']['entity'][0]['reference_id'] ??
  //         result['otpresponse']['entity']['reference_id'];
  //     OnyxFlushBar.showSuccess(
  //         context: context, message: 'Otp sent succesfully');
  //     resetTimer();
  //   } on DeadlineExceededException {
  //     OnyxFlushBar.showFailure(
  //         context: context,
  //         failure: UserDefinedException(
  //           "connection Time out",
  //           "Please check your internet connection and try again",
  //         ));
  //   } on NoInternetConnectionException {
  //     OnyxFlushBar.showFailure(
  //         context: context,
  //         failure: UserDefinedException(
  //           "No Internet connection",
  //           "Please check your internet connection and try again",
  //         ));
  //   } on Failure {
  //     OnyxFlushBar.showFailure(
  //         context: context,
  //         failure:
  //             UserDefinedException('Something went wrong', 'Please try again'));
  //   }
  // }
  checkPin() {}
  @override
  void dispose() {
    buytimer.cancel();
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  BuyViewModel() {
    // isLoading = true;
    // getMarketValue();
    // isLoading = false;
    getAssetBalance();
    buytimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_localCache.getToken() != null || !isDisposed) {
        getMarketValue();
      } else {
        timer.cancel();
      }
    });
  }
}
