import 'package:clipboard/clipboard.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/chatMessgaeModel.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/views/wallets/models/nairatransaction_model.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/flushbar.dart';
import 'package:onyxswap/widgets/transaction_successful.dart';

import '../../../core/constants/routeargument_key.dart';
import '../../../core/constants/textstyle.dart';
import '../../../models/exceptions.dart';
import '../../../models/failure.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/locator.dart';
import '../../../utils/text.dart';
import '../../../widgets/pin_bottomsheet.dart';
import '../../../widgets/two_factor_widget.dart';

class WalletViewModels extends BaseViewModel {
  List<dynamic> transactions = [];
  final NetworkClient _networkClient = NetworkClient();
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> twoFAformKey = GlobalKey<FormState>();
  List nairatransactions = [];
  List reversedTransactions = [];
  String? withdrawcharges;
  List? banks;
  String? bank;
  bool chargeLoading = false;
  String hint = 'Select Bank';
  bool haserror = false;
  getTransaction(String asset, BuildContext context) async {
    isLoading = true;
    String? userId = _localCache.getToken();
    try {
      isLoading = true;
      print(asset);
      await _networkClient.post(ApiRoutes.transactions,
          body: FormData.fromMap({
            'userId': userId,
            'asset': asset == 'USDT' ? 'USDT_TRON' : asset
          }));
      transactions =
          asset == 'nairawallet' ? _networkClient.data : _networkClient.data;
      transactions = transactions.reversed.toList();
      print(transactions);
      if (!isDisposed) {
        notifyListeners();
      }

      if (asset == 'nairawallet') {
        //getnairatransaction();
      }
      isLoading = false;
    } on DeadlineExceededException {
      Navigator.of(_navigationService.navigatorKey.currentContext!).pop();
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
              'Connection timeout', 'Please Check your internet connect '));
      // nairabalance = _localCache.getFromLocalCache('nairabalance').toString();
      isLoading = false;
    } on InvalidCredentialException {
      Navigator.of(_navigationService.navigatorKey.currentContext!).pop();
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
              'error', 'Please verify your BVN to create Naira wallet '));
      isLoading = false;
    } on InternalServerErrorException {
      Navigator.of(_navigationService.navigatorKey.currentContext!).pop();
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
              'error', 'Something went wrong please try again'));
      isLoading = false;
    } on NoInternetConnectionException {
      Navigator.of(_navigationService.navigatorKey.currentContext!).pop();
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "No internet connection",
            "Please connect to the internet and try again",
          ));
      isLoading = false;
    }
  }

  // getNairatransaction(BuildContext context) async {
  //   try{
  //   String? userId = _localCache.getToken();
  //   await _networkClient.post(ApiRoutes.transactions,
  //       body: FormData.fromMap({'userId': userId, 'asset': 'nairawallet'}));
  //   Map<String, dynamic> response = _networkClient.data;
  //   print(response);
  //   }on InternalServerErrorException{
  //       OnyxFlushBar.showFailure(
  //         context: context,
  //         failure: UserDefinedException(
  //             'error', 'Something went wrong please try again'));
  //     isLoading = false;
  //   }
  // }

  nairaDeposit(BuildContext context) async {
    try {
      String? userId = _localCache.getToken();
      await _networkClient.post(ApiRoutes.nairaDeposit,
          body: FormData.fromMap({
            'userId': userId,
          }));
      Map<String, dynamic> result = _networkClient.data;
      showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (context) => Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      AppText.heading6L(
                        'Deposit to your naira wallet using the details below',
                        color: kSecondaryColor,
                        centered: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText.body1L(
                            'Bank Name:',
                            color: kSecondaryColor,
                          ),
                          Spacer(),
                          Center(
                            child: AppText.body1L(
                              result['bankname'],
                              textAlign: TextAlign.center,
                              centered: true,
                              color: kSecondaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText.body1L(
                            'Account Number:',
                            color: kSecondaryColor,
                          ),
                          Spacer(),
                          AppText.body1L(
                            result['accounnumber'],
                            color: kSecondaryColor,
                          ),
                          IconButton(
                              onPressed: () async {
                                await FlutterClipboard.copy(
                                    result['accounnumber']);
                                OnyxFlushBar.showSuccess(
                                    context: context, message: 'Copied');
                              },
                              icon: const Icon(
                                Icons.copy,
                                color: kSecondaryColor,
                              ))
                        ],
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      const Spacer(),
                      AppButton(
                        title: 'Confirm',
                        backgroundColor: kSecondaryColor,
                        textColor: kPrimaryColor,
                        onTap: () => Navigator.pop(context),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AppText.body2L(
                        'Please do not write crypto related statements in your narration during depositing',
                        color: Colors.red,
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ));
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Something Went wrong",
            "Please try again",
          ));
      isLoading = false;
      //   Navigator.pop(context);
      //notifyListeners();
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "No internet connection",
            "Please connect to the internet and try again",
          ));
      isLoading = false;
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Connection Time out",
            "Please connect to the internet and try again",
          ));
      isLoading = false;
    }
  }

  String getBalance() {
    String? nairaBalance = _localCache.getFromLocalCache('nairabalance') != null
        ? _localCache.getFromLocalCache('nairabalance').toString()
        : '0.00';
    return nairaBalance;
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
            value: bank,
            iconSize: 30,
            style: body3L.copyWith(color: kSecondaryColor),
            hint: AppText.body3L(hint),
            onChanged: (value) => onChanged(value!),
            items: banks
                ?.map((item) => buildMenuItem(
                    item[4].toString(), item[3].toString(), item[2].toString()))
                .toList()),
      ),
    );
  }

  onChanged(String e) {
    bank = e;
    notifyListeners();
  }

  DropdownMenuItem<String> buildMenuItem(
      String bankname, String accountnumber, String bankCode) {
    return DropdownMenuItem<String>(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        AppText.body1L(
          bankname,
          color: kSecondaryColor,
        ),
        AppText.body1L(
          accountnumber,
          color: kSecondaryColor,
        )
      ]),
      value: bankCode + ' ' + accountnumber,
    );
  }

  fetchbank(BuildContext context) async {
    String? userid = _localCache.getToken();
    try {
      isLoading = true;
      await _networkClient.post(ApiRoutes.fetchbank,
          body: FormData.fromMap({'userid': userid}));
      banks = _networkClient.data['success'];
      notifyListeners();
      isLoading = false;
      print(bank);
    } on InvalidCredentialException {
      OnyxFlushBar.showFailure(
        context: context,
        failure: UserDefinedException(
          "No bank added",
          "No Bank added. A a bank",
        ),
      );
      _navigationService.navigateTo(NavigatorRoutes.addBank);
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
        context: context,
        failure: UserDefinedException(
          "Error",
          "Something went wrong try again",
        ),
      );
      isLoading = false;
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Connection Time out",
            "Please connect to the internet and try again",
          ));
      isLoading = false;
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "No internet connection",
            "Please connect to the internet and try again",
          ));
      isLoading = false;
    }
  }

  twoFA(
      {required TextEditingController twoFA,
      required String amount,
      required TextEditingController pin}) async {
    if (formKey.currentState!.validate()) {
      if (bank == null) {
        haserror = true;
      } else {
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
                      if (twoFAformKey.currentState!.validate()) {
                        Navigator.pop(context);
                        try {
                          isLoading = true;
                          var response = await _networkClient.post('/verify2fa',
                              body: FormData.fromMap(
                                  {'userid': userid, 'twofacode': twoFA.text}));
                          isLoading = false;
                          onTap(amount, pin);
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
                    formKey: twoFAformKey));
            isLoading = false;
             twoFA.clear();
          } else if (response['status'] == 403) {
            onTap(amount, pin);
            isLoading = false;
          }
        } on InvalidCredentialException {
          onTap(amount, pin);
          isLoading = false;
        } on Failure catch (e) {
          OnyxFlushBar.showError(title: e.title, message: e.message);
          isLoading = false;
        }
      }
    }
  }

  onTap(String amount, TextEditingController pin) async {
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
      isLoading = false;
      showModalBottomSheet(
          context: _navigationService.navigatorKey.currentContext!,
          enableDrag: false,
          isDismissible: false,
          isScrollControlled: true,
          backgroundColor: AppColors.backgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (context) => PinBottomSheet(
                isloading: isLoading,
                amount: amount,
                controller: pin,
                onCompleted: (value) async {
                  Navigator.pop(context);
                  try {
                    isLoading = true;
                    String? userid = _localCache.getToken();
                    await _networkClient.post(ApiRoutes.checkpin,
                        body: FormData.fromMap({
                          'userId': userid,
                          'checkPin': 1,
                          'appPinVal': pin.text
                        }));
                    try {
                      String? userid = _localCache.getToken();
                      String bankcode = bank!.split(' ')[0];
                      String accountNumber = bank!.split(' ')[1];
                      print(bank);
                      isLoading = true;
                      await _networkClient.post(ApiRoutes.payout,
                          body: FormData.fromMap({
                            'userid': userid,
                            'amount': amount,
                            'bankcode': bankcode,
                            'accountnumber': accountNumber
                          }));
                      Map<String, dynamic> result = _networkClient.data;
                      if (result.containsKey('error')) {
                        OnyxFlushBar.showFailure(
                          context:
                              _navigationService.navigatorKey.currentContext!,
                          failure: UserDefinedException(
                            "Error",
                            result['error'],
                          ),
                        );
                        isLoading = false;
                      } else {
                        isLoading = false;
                        Navigator.push(
                            _navigationService.navigatorKey.currentContext!,
                            MaterialPageRoute(
                                builder: (context) => TransactionSuccessful(
                                    heading: 'Withdrawal Successful',
                                    subHeading:
                                        'You have Successfully withdrawn $amount naira to Your account')));
                      }
                    } on Failure catch (e) {
                      OnyxFlushBar.showError(
                          title: e.title, message: e.message);
                      isLoading = false;
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
                    pin.clear();
                    //pin.dispose();
                    isLoading = false;
                  } on Failure catch (e) {
                    OnyxFlushBar.showError(title: e.title, message: e.message);
                    isLoading = false;
                  }
                  isLoading = false;
                },
              ));
    }
  }

  getCharge(String amount) async {
    try {
      chargeLoading = true;
      if (!isDisposed) {
        notifyListeners();
      }
      //String? userid = _localCache.getToken();
      Map<String, dynamic> result = await _networkClient.post('/payoutcharges',
          body: FormData.fromMap({'amount': amount}));
      withdrawcharges = result['payoutcharges'];
      chargeLoading = false;
      if (!isDisposed) {
        notifyListeners();
      }
    } on InvalidCredentialException {
      OnyxFlushBar.showError(
          title: 'Error', message: 'Error fetching payout charges');
      chargeLoading = false;
      if (!isDisposed) {
        notifyListeners();
      }
    } on Failure catch (e) {
      OnyxFlushBar.showError(title: e.title, message: e.message);
      chargeLoading = false;
      if (!isDisposed) {
        notifyListeners();
      }
    }
  }

  getnairatransaction() async {
    try {
      isLoading = true;
      for (int i = 0; i < transactions.length; i++) {
        Map<String, dynamic> response = await _networkClient.post(
            ApiRoutes.nairaTransaction,
            body: FormData.fromMap({
              'transaction_id': transactions[i][2],
              'wallet_id': transactions[i][3]
            }));
        if (nairatransactions.contains(
            NairaTransationModel.fromJson(response).entity.transactionId)) {
        } else {
          nairatransactions.add(NairaTransationModel.fromJson(response));
        }

        notifyListeners();
      }
      //   Future.wait([
      //     for (int i = 0; i < transactions.length; i++) {
      //     Map<String, dynamic> response = await _networkClient.post(
      //         ApiRoutes.nairaTransaction,
      //         body: FormData.fromMap({
      //           'transaction_id': transactions[i][2],
      //           'wallet_id': transactions[i][3]
      //         }));
      //     }
      //  ] );
      isLoading = false;
      print(nairatransactions);
    } on Failure catch (e) {
      OnyxFlushBar.showError(title: e.title, message: e.message);
      isLoading = false;
    }
    isLoading = false;
  }

  // checkPin(
  //     {required String amount,
  //     required TextEditingController pin,
  //     required BuildContext context}) async {
  //   try {
  //     String? userid = _localCache.getToken();
  //     print(userid);
  //     isLoading = true;

  //     await _networkClient.post(ApiRoutes.checkpin,
  //         body: FormData.fromMap(
  //             {'userId': userid, 'checkPin': 1, 'appPinVal': pin.text}));
  //     onTap(amount, context);
  //     pin.clear();

  //     isLoading = false;
  //   } on InvalidCredentialException {
  //     // Navigator.pop(context);
  //     OnyxFlushBar.showFailure(
  //       context: _navigationService.navigatorKey.currentContext!,
  //       failure: UserDefinedException(
  //         "Pin  Incorrect",
  //         "Incorrect Pin",
  //       ),
  //     );
  //     pin.clear();
  //     //pin.dispose();
  //     isLoading = false;
  //   } on InternalServerErrorException {
  //     OnyxFlushBar.showFailure(
  //         context: _navigationService.navigatorKey.currentContext!,
  //         failure: UserDefinedException(
  //           "Something Went wrong",
  //           "Please try again",
  //         ));
  //     isLoading = false;
  //     //   Navigator.pop(context);
  //     //notifyListeners();
  //   } on NoInternetConnectionException {
  //     OnyxFlushBar.showFailure(
  //         context: _navigationService.navigatorKey.currentContext!,
  //         failure: UserDefinedException(
  //           "No internet connection",
  //           "Please connect to the internet and try again",
  //         ));
  //     isLoading = false;
  //   } on DeadlineExceededException {
  //     OnyxFlushBar.showFailure(
  //         context: _navigationService.navigatorKey.currentContext!,
  //         failure: UserDefinedException(
  //           "Connection Time out",
  //           "Please connect to the internet and try again",
  //         ));
  //     isLoading = false;
  //   }
  //   isLoading = false;
  // }
}
