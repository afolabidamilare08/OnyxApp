import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onyxswap/core/constants/routeargument_key.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/models/push_notification_model.dart';
import 'package:onyxswap/utils/locator.dart';

import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/custom_alert_dialogue.dart';
import 'package:onyxswap/widgets/flushbar.dart';
import 'package:onyxswap/widgets/pin_bottomsheet.dart';

import '../../../core/constants/textstyle.dart';

import '../../../core/routes/routing_constants.dart';
import '../../../models/failure.dart';
import '../../../utils/color.dart';
import '../../../utils/network_client.dart';
import '../../../utils/text.dart';
import '../../../widgets/transaction_successful.dart';
import '../../Security/component/setup_pin.dart';

class ElectricityViewmodel extends BaseViewModel {
  List<Map<String, String>> selectbiller = [
    {'name': 'IKEDC – Ikeja Electricity', 'value': 'ikeja-electric'},
    {'name': 'EKEDC – Eko Electricity', 'value': 'eko-electric'},
    {'name': 'KEDCO – Kano Electricity', 'value': 'kano-electric'},
    {
      'name': 'PHED – Port Harcourt Electricity',
      'value': 'portharcourt-electric'
    },
    {'name': 'JED – Jos Electricity', 'value': 'jos-electric'},
    {'name': 'IBEDC – Ibadan Electricity', 'value': 'ibadan-electric'},
    {'name': 'KAEDCO – Kaduna Electricity', 'value': 'kaduna-electric'},
    {'name': 'AEDC – Abuja Electricity', 'value': 'abuja-electric'},
  ];
  final LocalCache _localCache = locator<LocalCache>();
  List<String> paymentItem = [
    'Prepaid',
    'Postpaid',
  ];
  String selectbillerHintText = 'Select Biller';
  String paymentItemHintText = 'Select payment item';
  String? selectbillerText;
  String? paymentItemText;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final NetworkClient _networkClient = NetworkClient();
  LocalNotification localNotification = LocalNotification();
  final NavigationService _navigationService = NavigationService.I;
  selectBiller(String e) {
    selectbillerText = e;
    notifyListeners();
  }

  selectPaymentItem(String e) {
    paymentItemText = e;
    notifyListeners();
  }

  buildDropDown({
    required BuildContext context,
    String? mainvalue,
    String? hint,
    required List<DropdownMenuItem<String>> items,
    void Function(String?)? onChanged,
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
          value: mainvalue,
          iconSize: 30,
          style: body3L.copyWith(color: Colors.white),
          hint: AppText.body3L(
            hint ?? '',
            color: kSecondaryColor,
          ),
          onChanged: onChanged,
          items: items),
    );
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

  validateMeterNumber(
      {required String meterNumber,
      required BuildContext context,
      required String amount,
      required TextEditingController pin}) async {
    String? userid = _localCache.getToken();
    try {
      if (formKey.currentState!.validate()) {
        isLoading = true;
        await _networkClient.post(ApiRoutes.validateMeternumber,
            body: FormData.fromMap({
              'meternumber': meterNumber,
              'service_id': selectbillerText,
              'metertype': paymentItemText,
              'validateMeterNumber': 1
            }));
        if (_networkClient.data == 'Invalid Credentials') {
          OnyxFlushBar.showFailure(
              context: context,
              failure: UserDefinedException('Error', 'Invalid Credentials'));
          isLoading = false;
        } else {
          Map<String, dynamic> data = _networkClient.data['content'];
          if (data.containsKey('error')) {
            OnyxFlushBar.showFailure(
                context: context,
                failure: UserDefinedException('Error', data['error']));
            isLoading = false;
          } else {
            isLoading = false;
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(10), left: Radius.circular(10))),
                builder: (context) => CustomAlertDialogue(
                    accountName: data['Customer_Name'],
                    decoderNumber: data['MeterNumber'] ?? '',
                    bouquet: paymentItemText!,
                    amount: amount,
                    type: 'Meter Type',
                    onTap: () async {
                      try {
                        Navigator.pop(context);
                        isLoading = true;
                        await _networkClient.post(ApiRoutes.checkApppin,
                            body: FormData.fromMap({'userId': userid}));
                        Map<String, dynamic> result = _networkClient.data;
                        if (result['status'] == 403) {
                          _navigationService
                              .navigateTo(NavigatorRoutes.pinSetup, argument: {
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
                              context: formKey.currentContext!,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(10),
                                      left: Radius.circular(10))),
                              builder: (context) => PinBottomSheet(
                                    amount: amount,
                                    controller: pin,
                                    isloading: isLoading,
                                    onCompleted: (value) {
                                      Navigator.pop(_navigationService
                                          .navigatorKey.currentContext!);
                                      checkPin(
                                          pin: pin,
                                          cardnumber: meterNumber,
                                          context: context,
                                          amount: amount);
                                    },
                                  ));
                          isLoading = false;
                        }
                      } on Failure catch (e) {
                        OnyxFlushBar.showError(
                            title: e.title, message: e.message);
                            isLoading = false;
                      }
                    }));
          }
        }
      }
    } on Failure catch (e) {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            e.title,
            e.message,
          ));
      isLoading = false;
    }
  }

  payElectricity(
      {required String cardNumber,
      required String amount,
      required BuildContext context}) async {
    try {
      isLoading = true;
      String? userid = _localCache.getToken();
      await _networkClient.post(ApiRoutes.payElectricity,
          body: FormData.fromMap({
            'meternumber': cardNumber,
            'service_id': selectbillerText,
            'metertype': paymentItemText,
            'payElectricity': 1,
            'amount': amount,
            'userId': userid
          }));
      Map<String, dynamic> result = _networkClient.data;
      if (_networkClient.data['response_description'] ==
              'TRANSACTION SUCCESSFUL' ||
          result['content'].containsKey('error')) {
        _navigationService
            .navigateTo(NavigatorRoutes.transactionSuccess, argument: {
          RouteArgumentkeys.heading: 'Electricity bill Payment Succesful',
          RouteArgumentkeys.subheading:
              'You have succesfully purchased ${result['amount'].toString()}for Electricity \n Your Meter ${result['purchased_code'].toString()}'
        });
        isLoading = false;
        await LocalNotification.showNotification(
            title: 'Electricity bill Payment Succesful',
            body: 'Your Meter ${result['purchased_code'].toString()}',
            payload: result['purchased_code'].toString());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => TransactionSuccessful(
        //       heading: 'Bill Payment Succesful',
        //       subHeading:
        //           'You have succesfully purchased ${result['amount'].toString()}for Electricity \n Your Meter ${result['purchased_code'].toString()} ',
        //     ),
        //   ),
        // );
        return result;
      } else {
        OnyxFlushBar.showFailure(
            context: context,
            failure: UserDefinedException(
              "Error",
              _networkClient.data['response_description'],
            ));
        isLoading = false;
        return result;
      }
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "Something Went wrong",
            "Please try again",
          ));
      isLoading = false;
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "No internet connection",
            "Please try again",
          ));
      //pin.clear();
      isLoading = false;
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "Connection Time out",
            "Please try again",
          ));
      //pin.clear();
      isLoading = false;
    } on InvalidCredentialException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "Insufficient Funds",
            "Insufficient amount in naira wallet",
          ));
    } on UnauthorizedException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Error",
            "Duplicate Transaction please try again later",
          ));
      isLoading = false;
    }
  }

  checkPin(
      {required TextEditingController pin,
      required String cardnumber,
      required BuildContext context,
      required String amount}) async {
    try {
      String? userid = _localCache.getToken();
      print(userid);
      isLoading = true;
      await _networkClient.post(
        ApiRoutes.checkpin,
        body: FormData.fromMap(
          {'appPinVal': pin.text, 'userId': userid, 'checkPin': 1},
        ),
      );
      payElectricity(cardNumber: cardnumber, amount: amount, context: context);
      pin.clear();
      isLoading = false;
    } on InvalidCredentialException {
      OnyxFlushBar.showFailure(
        context: context,
        failure: UserDefinedException(
          "Pin  Incorrect",
          "Incorrect Pin",
        ),
      );
      pin.clear();
      isLoading = false;
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "Something Went wrong",
            "Please try again",
          ));
      pin.clear();
      isLoading = false;
      //notifyListeners();
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "No internet connection",
            "Please try again",
          ));
      pin.clear();
      isLoading = false;
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "Connection Time out",
            "Please try again",
          ));
      pin.clear();
      isLoading = false;
    } on Failure catch (e) {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            e.title,
            e.message,
          ));
      pin.clear();
      isLoading = false;
    }
    isLoading = false;
  }

  ElectricityViewmodel() {
    localNotification.initialise();
    listenToNotification();
  }

  void listenToNotification() => localNotification.onNotificationClick.stream
      .listen(onNotificationListener);

  void onNotificationListener(NotificationResponse? event) {
    _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
  }
}
