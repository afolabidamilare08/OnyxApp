// ignore_for_file: file_names

import 'package:contacts_service/contacts_service.dart';
//import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications_platform_interface/src/types.dart';
import 'package:lottie/lottie.dart';
import 'package:onyxswap/core/constants/routeargument_key.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/core/services/navigation_service.dart';

import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/models/failure.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/views/Security/component/setup_pin.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

import '../../../core/constants/textstyle.dart';

import '../../../data/local/local_cache/local_cache.dart';
import '../../../models/push_notification_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../../../widgets/flushbar.dart';
import '../../../widgets/pin_bottomsheet.dart';
import '../../../widgets/transaction_successful.dart';
import 'package:permission_handler/permission_handler.dart';

class BuyAirtimeViewmodel extends BaseViewModel {
  List<Contact> contacts = [];
  List<Contact> filteredcontacts = [];
  List<String> selectbiller = ['MTN', 'Airtel', 'Glo', "9mobile"];
  String selectbillerText = 'Network';
  List<String> airtime = ['Airtime', 'Data'];
  String airtimeText = 'Airtime';
  String result = '';
  String? biller;
  String? data;
  String selectbillers = 'Network';
  String dataPlan = 'Select Data Plan';
  final NetworkClient _networkClient = NetworkClient();
  List<dynamic>? dataPakages;
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  bool isBillerError = false;
  bool isDataError = false; 
  LocalNotification localNotification = LocalNotification();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //String e;
  getContactList() async {
    // if (await ContactsService.requestPermission()) {
    if (await Permission.contacts.request().isGranted) {
      contacts = await ContactsService.getContacts(
        withThumbnails: false,
      );
      print(contacts);
      notifyListeners();
    } else {
      Navigator.pop(_navigationService.navigatorKey.currentContext!);
    }

    // }
  }

  selectBiller(String e) {
    airtimeText = e;
    notifyListeners();
  }

  selectdataplan(String e) {
    data = e;
    notifyListeners();
  }

  selectNetwork(String e) {
    biller = e;
    notifyListeners();
  }

  selectNetwork2(String e) {
    biller = e;
    notifyListeners();
  }

  DropdownMenuItem<String> buildMenuItem(
      {required String item, required String value}) {
    return DropdownMenuItem<String>(
      child: AppText.body1L(
        item,
        color: kPrimaryColor,
      ),
      //value: '$value $amount',
      value: value,
    );
  }

  DropdownMenuItem<String> buildMenuItem2(
      {required String item, required String value, String? amount}) {
    return DropdownMenuItem<String>(
      child: AppText.body1L(
        item,
        color: kPrimaryColor,
      ),
      value: '$value $amount',
      //value: value,
    );
  }

  validatePhone(String phoneNumer) async {
    try {
      isLoading = true;
      Map<String, dynamic> response = await _networkClient.post(
          ApiRoutes.validatePhonenumber,
          body: FormData.fromMap({'phonenumber': phoneNumer}));
      print(response);
      isLoading = false;
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Something Went wrong",
            "Please try again",
          ));
      isLoading = false;
    }
  }

  buildDropDown({
    required BuildContext context,
    String? mainvalue,
    String? hint,
    required List<DropdownMenuItem<String>>? items,
    required void Function(String) function,
    void Function(String?)? onChanged,
    // dynamic? item,
    // String? value
    //required Function(List<dynamic>)? mapped
  }) {
    return ButtonTheme(
      alignedDropdown: false,
      child: DropdownButton2<String>(
          isExpanded: true,
          dropdownWidth: MediaQuery.of(context).size.width - 40,
          dropdownFullScreen: false,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kSecondaryColor,
          ),
          offset: const Offset(-10, -20),
          value: mainvalue,
          iconSize: 30,
          style: body3L,
          hint: AppText.body3L(
            hint ?? '',
            color: kPrimaryColor,
          ),
          onChanged: onChanged,
          items: items
          ),
    );
  }

  getDataPackages() async {
    try {
      isLoading = true;
      await _networkClient.post(ApiRoutes.dataPackages,
          body: FormData.fromMap({
            'selectedServiceNetwork': biller == '9mobile'
                ? 'etisalat-data'
                : '${biller!.toLowerCase()}-data'
          }));
      dataPakages = _networkClient.data['content']['varations'];
      notifyListeners();
      isLoading = false;
      print(dataPakages);
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

  airtimeTopup({
    required String phoneNumber,
    required String amount,
    required int? network,
    required String biller,
    required String serviceid,
  }) async {
    try {
      isLoading = true;
      String? userid = _localCache.getToken();
      // if(network==null){

      // }
      Map<String, dynamic> result = await _networkClient.post(
        ApiRoutes.airtimeTopup,
        body: FormData.fromMap(
          {
            'selectbiller': biller,
            'selectNetwork': network,
            'amount': amount,
            'phonenumber': phoneNumber,
            'service_id': serviceid,
            "userid":userid
          },
        ),
      );
      Map<String, dynamic> data = _networkClient.data['content'];
      if (data.containsKey('errors') ||
          _networkClient.data['response_description'] == 'TRANSACTION FAILED') {
        OnyxFlushBar.showFailure(
            context: _navigationService.navigatorKey.currentContext!,
            failure: UserDefinedException(
              "Error",
              '${_networkClient.data['response_description']} Please check the number and try again',
            ));
        isLoading = false;
      } else {
        _navigationService
            .navigateTo(NavigatorRoutes.transactionSuccess, argument: {
          RouteArgumentkeys.heading: 'Airtime Successful',
          RouteArgumentkeys.subheading:
              'You have just purchased N$amount airtime'
        });
        await LocalNotification.showNotification(
            title: 'Airtime Successful',
            body: 'You have just purchased N$amount airtime for $phoneNumber');
        // Navigator.push(
        //     _navigationService.navigatorKey.currentContext!,
        //     MaterialPageRoute(
        //         builder: (context) => TransactionSuccessful(
        //               heading: 'Airtime Successful',
        //               subHeading: 'You have just purchased ₦$amount airtime',
        //             )));
        isLoading = false;
      }
      return result;
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
            "Transaction failed",
            "Insufficient amount in naira wallet",
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
            'This might be a duplicate transaction, Please try again after some minutes',
          ));
      isLoading = false;
    }
  }

  dataTopup(
      {required String phonenumber,
      required String variation_code,
      required String serviceid,
      required String biller,
      required String amount}) async {
    try {
      isLoading = true;
      Map<String, dynamic> result =
          await _networkClient.post(ApiRoutes.airtimeTopup,
              body: FormData.fromMap({
                'service_id': serviceid,
                'variation_code': variation_code,
                'phonenumber': phonenumber,
                'selectbiller': biller,
                'amount': amount
              }));
      Map<String, dynamic> data = _networkClient.data['content'];
      if (data.containsKey('errors')) {
        OnyxFlushBar.showFailure(
            context: _navigationService.navigatorKey.currentContext!,
            failure: UserDefinedException(
              "Error",
              _networkClient.data['response_description'],
            ));
      } else {
        _navigationService
            .navigateTo(NavigatorRoutes.transactionSuccess, argument: {
          RouteArgumentkeys.heading: 'Data purchase Successful',
          RouteArgumentkeys.subheading:
              'You have just purchased ₦${amount.toString()} Data'
        });
        await LocalNotification.showNotification(
            title: 'Data Successful',
            body: 'You have just purchased N$amount airtime for $phonenumber');
        // Navigator.push(
        //     _navigationService.navigatorKey.currentContext!,
        //     MaterialPageRoute(
        //         builder: (context) => TransactionSuccessful(
        //               heading: 'Airtime Successful',
        //               subHeading:
        //                   'You have just purchased ₦${data['transactions']['amount'].toString()} airtime',
        //             )));
      }
      isLoading = false;
      return result;
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
            "This might be a duplicate transaction, Please try again after some minutes",
          ));
      isLoading = false;
    }
  }

  checkPin(
      {required TextEditingController pin,
      required String phoneNumber,
      required String amount,
      required String biller,
      required String serviceid,
      required String variation_code,
      required BuildContext context,
      required variationAmount}) async {
    try {
      String? userid = _localCache.getToken();
      print(userid);
      isLoading = true;

      await _networkClient.post(ApiRoutes.checkpin,
          body: FormData.fromMap(
              {'userId': userid, 'checkPin': 1, 'appPinVal': pin.text}));
              isLoading = false;
      if (airtimeText == 'Airtime') {
        //isLoading = true;
        airtimeTopup(
            phoneNumber: phoneNumber,
            amount: amount,
            network: 1,
            biller: biller,
            serviceid: serviceid);
        isLoading = false;
      } else if (airtimeText == 'Data') {
        isLoading = true;
        dataTopup(
            phonenumber: phoneNumber,
            variation_code: variation_code,
            serviceid: '$serviceid-data',
            biller: biller,
            amount: variationAmount);
      }
      pin.clear();
      //isLoading = false;
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
    }
    isLoading = false;
  }

  onContinueTap({
    required BuildContext context,
    required String phone,
    required String amount,
    required TextEditingController pin,
    //required BuildContext context,
  }) async {
    String? userid = _localCache.getToken();
    if (formKey.currentState!.validate()) {
      if (biller == null) {
        isBillerError = true;
        notifyListeners();
      } else if (airtimeText == 'Data' && data == null) {
        isDataError = true;
        notifyListeners();
      } else {
        await validatePhone(phone);
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
              context: context,
              enableDrag: false,
              isDismissible: false,
              isScrollControlled: true,
              backgroundColor: AppColors.backgroundColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              builder: (context) => Stack(
                children:[
                PinBottomSheet(
                isloading: isLoading,
                amount: amount,
                controller: pin,
                onCompleted: (value) async {
                    Navigator.pop(context);
                  print(data);
                  isLoading = true;
                  await checkPin(
                      variation_code:
                          data == null ? '' : data!.split(' ')[0],
                      variationAmount:
                          data == null ? '' : data!.split(' ')[1],
                      pin: pin,
                      phoneNumber: phone,
                      amount: amount,
                      context: context,
                      //network: model.biller,
                      biller: airtimeText,
                      serviceid: biller ?? ''.toLowerCase());
                  isLoading = false;
                },
              ),
             
            isLoading?  Container(
                height: (MediaQuery.of(context).size.height*2)/3,
                width: MediaQuery.of(context).size.width,
                 decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                      color: Colors.black.withOpacity(0.35),
                 ),
              child:  SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                        child: 
                        Lottie.asset("assets/lotties/loader.json",height: 40,width: 40)
                        )),
              ):SizedBox()
              ])
            );
          }
          // if (Platform.isIOS) {
          //   showCupertinoModalPopup(
          //     context: context,
          //     builder: (context) => Scaffold(
          //       body: Column(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         children: [
          //           PinBottomSheet(
          //             isloading: isLoading,
          //             amount: amount,
          //             controller: pin,
          //             onCompleted: (value) async {
          //               await checkPin(
          //                   variation_code: data ?? '',
          //                   pin: pin.text,
          //                   phoneNumber: phone,
          //                   amount: amount,
          //                   //network: model.biller,
          //                   biller: airtimeText,
          //                   serviceid: biller ?? ''.toLowerCase());
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   );
          // } else {
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
        } on DeadlineExceededException {
          OnyxFlushBar.showFailure(
              context: context,
              failure: UserDefinedException(
                "connection Time out",
                "Please check your internet connection and try again",
              ));
          isLoading = false;
        }
      }
    }
  }

  networkOnchanged(String? e) {
    if (dataPakages != null) {
      dataPakages!.clear();
      data = null;
    }
    selectNetwork(e!);
    if (airtimeText == 'Data') {
      getDataPackages();
    }
    notifyListeners();
  }

  BuyAirtimeViewmodel() {
    localNotification.initialise();
    listenToNotification();
  }

  void listenToNotification() => localNotification.onNotificationClick.stream
      .listen(onNotificationListener);

  void onNotificationListener(NotificationResponse? event) {
    _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
  }
}
