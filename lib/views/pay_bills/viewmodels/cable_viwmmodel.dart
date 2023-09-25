import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/models/failure.dart';
import 'package:onyxswap/views/pay_bills/components/cable_bottomsheet.dart';

import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/pin_bottomsheet.dart';

import '../../../core/constants/routeargument_key.dart';
import '../../../core/constants/textstyle.dart';

import '../../../core/routes/routing_constants.dart';
import '../../../core/services/navigation_service.dart';
import '../../../data/local/local_cache/local_cache.dart';
import '../../../models/exceptions.dart';
import '../../../models/push_notification_model.dart';
import '../../../utils/color.dart';
import '../../../utils/locator.dart';
import '../../../utils/network_client.dart';
import '../../../utils/text.dart';
import '../../../widgets/custom_alert_dialogue.dart';
import '../../../widgets/flushbar.dart';
import '../../../widgets/transaction_successful.dart';
import '../../Security/component/setup_pin.dart';

class CableViewmodel extends BaseViewModel {
  bool value = false;
  List<String> type = ['gotv.png', 'startimes.png', 'dstv.png'];
  String selectedType = '';
  List<dynamic>? subscription;
  String? text;
  String hint = 'subsription plan';
  final NetworkClient _networkClient = NetworkClient();
  final NavigationService _navigationService = NavigationService.I;
  String? serviceId;
  Map<String, dynamic>? cardnumberValidated;
  final LocalCache _localCache = locator<LocalCache>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isBillerError = false;
  bool isSubsriptionError = false;
  LocalNotification localNotification = LocalNotification();
  toggle(value) {
    value = !value;
    notifyListeners();
  }

  onTap(int index) {
    selectedType = type[index];
    notifyListeners();
  }

  onChanged(String e) {
    text = e;
    notifyListeners();
  }

  DropdownMenuItem<String> buildMenuItem(
      String item, String value, String amount) {
    return DropdownMenuItem<String>(
      child: AppText.body1L(
        item,
        color: kSecondaryColor,
      ),
      value: '$value $amount',
    );
  }

  selectSubscriptionplan(String e) {
    text = e;
    notifyListeners();
  }

  buildDropDown({
    required BuildContext context,
  }) {
    return ButtonTheme(
      alignedDropdown: false,
      child: DropdownButton2<String>(
          isExpanded: true,
          dropdownWidth: MediaQuery.of(context).size.width - 40,
          dropdownFullScreen: false,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kPrimaryColor,
          ),
          offset: const Offset(-10, -20),
          value: text,
          iconSize: 30,
          style: body3L,
          hint: AppText.body3L(
            hint,
            color: kSecondaryColor,
          ),
          onChanged: (e) => selectSubscriptionplan(e!),
          items: subscription
              ?.map((e) => buildMenuItem(
                  e['name'], e['variation_code'], e['variation_amount']))
              .toList()),
    );
  }

  getSubsciptionPlan() async {
    try {
      isLoading = true;
      await _networkClient.post(ApiRoutes.getSubscritionPlan,
          body: FormData.fromMap({'service_id': serviceId}));
      notifyListeners();
      subscription = _networkClient.data['content']['varations'];
      //text = subscription![0]['name'];
      print(serviceId);
      notifyListeners();
      print(text);
      isLoading = false;
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Connection Time out",
            "Please try again",
          ));
      isLoading = false;
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Something Went wrong",
            "Please try again",
          ));
      isLoading = false;
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "No Internet Connection",
            "Please connect to the internet and try again",
          ));
      isLoading = false;
    } on Failure {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Something Went wrong",
            "Please try again",
          ));
      isLoading = false;
    }
  }

  Future<Map<String, dynamic>> validateCardnumber({
    required String cardnumber,
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    String? userid = _localCache.getToken();
    try {
      isLoading = true;
      await _networkClient.post(ApiRoutes.validateCardnumber,
          body: FormData.fromMap(
              {'cardnumber': cardnumber, 'service_id': serviceId}));
      cardnumberValidated = _networkClient.data['content'];
      if (cardnumberValidated!.containsKey('error')) {
        OnyxFlushBar.showFailure(
            context: _navigationService.navigatorKey.currentContext!,
            failure: UserDefinedException(
              "Error",
              cardnumberValidated!['error'],
            ));
        isLoading = false;
      } else {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (context) => serviceId == 'startimes'
              ? CustomAlertDialogue(
                  accountName: cardnumberValidated!['Customer_Name'],
                  decoderNumber:
                      cardnumberValidated!['Smartcard_Number'].toString(),
                  bouquet: '',
                  amount: '',
                  onTap: () async {
                    Navigator.pop(context);
                    // isLoading = true;
                    try {
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => PinSetup(
                        //             heading: 'Create Transaction pin',
                        //             title: 'pin',
                        //             subtitle: 'Confirm pin')));
                        isLoading = false;
                      } else if (result['status'] == 200) {
                        showModalBottomSheet(
                            context: formKey.currentContext!,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            builder: (context) => PinBottomSheet(
                                  amount: cardnumberValidated!['Renewal_Amount']
                                      .toString(),
                                  controller: controller,
                                  isloading: isLoading,
                                  onCompleted: (value) async {
                                    Navigator.pop(context);
                                    await checkPin(
                                        pin: controller,
                                        cardnumber: cardnumber,
                                        context: context,
                                        variationCode: text!.split(' ')[0],
                                        currentBouquetAmount:
                                            text!.split(' ')[1],
                                        amount: text!.split(' ')[1],
                                        subscriptionType: 'change');
                                  },
                                ));
                      }
                      isLoading = false;
                    } on InvalidCredentialException {
                      OnyxFlushBar.showError(
                          title: 'Error', message: 'Something went wrong');
                    } on Failure catch (e) {
                      OnyxFlushBar.showFailure(
                          context:
                              _navigationService.navigatorKey.currentContext!,
                          failure: UserDefinedException(
                            e.title,
                            e.message,
                          ));
                      isLoading = false;
                    }
                  },
                )
              : CableBottomSheet(
                  amount: text!.split(' ')[1],
                  currentBouquet: text!.split(' ')[0],
                  accountName: cardnumberValidated!['Customer_Name'],
                  decoderNumber: cardnumber,
                  bouquet: cardnumberValidated!['Current_Bouquet_Code'],
                  renewalAmount:
                      cardnumberValidated!['Renewal_Amount'].toString(),
                  type: 'Bouquet',
                  onTap: () {
                    Navigator.pop(
                        _navigationService.navigatorKey.currentContext!);
                    bouquetOntap(
                        controller: controller,
                        onCompleted: (value) async {
                          Navigator.pop(context);
                          print(controller.text);
                          print(cardnumber);
                          print(cardnumberValidated!['Renewal_Amount']
                              .toString());
                          print(cardnumberValidated!['Current_Bouquet_Code']
                              .toString());
                          await checkPin(
                            pin: controller,
                            context: context,
                            cardnumber: cardnumber,
                            amount: cardnumberValidated!['Renewal_Amount']
                                .toString(),
                            variationCode:
                                cardnumberValidated!['Current_Bouquet_Code']
                                    .toString(),
                            subscriptionType: 'renew',
                            currentBouquetAmount:
                                cardnumberValidated!['Renewal_Amount']
                                    .toString(),
                          );
                        });
                  },
                  onTap2: () {
                    Navigator.pop(
                        _navigationService.navigatorKey.currentContext!);
                    bouquetOntap(
                        controller: controller,
                        onCompleted: (value) async {
                          Navigator.pop(
                              _navigationService.navigatorKey.currentContext!);
                          print(controller.text);
                          print(cardnumber);
                          print(text!.split(' ')[0]);
                          print(text!.split(' ')[1]);

                          await checkPin(
                              pin: controller,
                              cardnumber: cardnumber,
                              context: context,
                              variationCode: text!.split(' ')[0],
                              currentBouquetAmount: text!.split(' ')[1],
                              amount: text!.split(' ')[1],
                              subscriptionType: 'change');
                        });
                  }),
        );
        isLoading = false;
      }
    } on Failure catch (e) {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            e.title,
            e.message,
          ));
      isLoading = false;
    }
    return cardnumberValidated ?? <String, dynamic>{};
  }

  bouquetOntap(
      {required TextEditingController controller,
      required,
      void Function(String)? onCompleted}) async {
    //Navigator.pop(_navigationService.navigatorKey.currentContext!);
    // isLoading = true;
    String? userid = _localCache.getToken();
    //print(object)
    try {
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
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => PinSetup(
        //             heading: 'Create Transaction pin',
        //             title: 'pin',
        //             subtitle: 'Confirm pin')));
        isLoading = false;
      } else if (result['status'] == 200) {
        showModalBottomSheet(
            context: formKey.currentContext!,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            builder: (context) => PinBottomSheet(
                  amount: cardnumberValidated!['Renewal_Amount'].toString(),
                  controller: controller,
                  isloading: isLoading,
                  onCompleted: onCompleted,
                ));
      }
      isLoading = false;
    } on Failure catch (e) {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            e.title,
            e.message,
          ));
      isLoading = false;
    }
  }

  checkPin({
    required TextEditingController pin,
    required String cardnumber,
    required BuildContext context,
    required String variationCode,
    required String currentBouquetAmount,
    required String amount,
    required String subscriptionType,
  }) async {
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
      buyCable(
        cardnumber: cardnumber,
        context: context,
        amount: amount,
        currentBouquetAmount: currentBouquetAmount,
        subscriptionType: subscriptionType,
        variationCode: variationCode,
      );
      pin.clear();
      isLoading = false;
    } on InvalidCredentialException {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "Pin  Incorrect",
          "Incorrect Pin",
        ),
      );
      pin.clear();
      isLoading = false;
    } on Failure catch (e) {
      OnyxFlushBar.showError(title: e.title, message: e.message);
      isLoading = false;
      pin.clear();
    }
  }

  buyCable({
    required String cardnumber,
    required BuildContext context,
    required String variationCode,
    required String currentBouquetAmount,
    required String amount,
    required String subscriptionType,
  }) async {
    try {
      String? userid = _localCache.getToken();
      Map<String, dynamic> result =
          await _networkClient.post(ApiRoutes.paycable,
              body: FormData.fromMap({
                'cardnumber': cardnumber,
                'subscrption_type': subscriptionType,
                'current_Bouquet_amount': currentBouquetAmount,
                'service_id': serviceId,
                'variation_code': variationCode,
                'userId': userid,
                'amount': amount
              }));
      print(text!.split(' ')[1]);
      if (_networkClient.data['response_description'] ==
          'TRANSACTION SUCCESSFUL') {
        _navigationService
            .navigateTo(NavigatorRoutes.transactionSuccess, argument: {
          RouteArgumentkeys.heading:
              '${serviceId!.toUpperCase()} Subscription Succesful',
          RouteArgumentkeys.subheading:
              'You have succesfully paid N${amount.toString()}for your ${serviceId!.toUpperCase()} Subscription'
        });
        LocalNotification.showNotification(
            title: '${serviceId!.toUpperCase()}  Successful',
            body:
                'You have succesfully paid N${amount.toString()}for your ${serviceId!.toUpperCase()} Subscription');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => TransactionSuccessful(
        //       heading: '${serviceId!.toUpperCase()} Subscription Succesful',
        //       subHeading:
        //           'You have succesfully paid ${cardnumberValidated!['Renewal_Amount'].toString()}for your ${serviceId!.toUpperCase()} Subscription',
        //     ),
        //   ),
        // );
        return result;
      } else {
        OnyxFlushBar.showFailure(
            context: _navigationService.navigatorKey.currentContext!,
            failure: UserDefinedException(
              "Error",
              _networkClient.data['response_description'],
            ));
        isLoading = false;
        return result;
      }
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Something Went wrong",
            "Please try again",
          ));
      isLoading = false;
    } on InvalidCredentialException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Insufficient Funds",
            " Insufficient amount in naira wallet",
          ));
      isLoading = false;
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Connection Time out",
            "Please try again",
          ));
      isLoading = false;
      isLoading = false;
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "No Internet Connection",
            "Please connect to the internet and try again",
          ));
      isLoading = false;
    } on UnauthorizedException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Error",
            "Duplicate Transaction please try again later",
          ));
      isLoading = false;
    } on Failure catch (e) {
      OnyxFlushBar.showError(title: e.title, message: e.message);
      isLoading = false;
    }
  }

  onCableTap(int index) {
    serviceId = type[index].split('.')[0];

    if (subscription != null) {
      subscription!.clear();
      text = null;
    }
    notifyListeners();

    getSubsciptionPlan();
  }

  onContinueTap(
      {required String cardNumber,
      required TextEditingController pin,
      required BuildContext context}) async {
    if (formKey.currentState!.validate()) {
      if (serviceId == null) {
        isBillerError = true;
        notifyListeners();
      } else if (text == null) {
        isSubsriptionError == true;
        notifyListeners();
      } else {
        await validateCardnumber(
          cardnumber: cardNumber,
          context: context,
          controller: pin,
        );
      }
    }
  }

  CableViewmodel() {
    localNotification.initialise();
    listenToNotification();
  }
  void listenToNotification() => localNotification.onNotificationClick.stream
      .listen(onNotificationListener);

  void onNotificationListener(NotificationResponse? event) {
    _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
  }
}
