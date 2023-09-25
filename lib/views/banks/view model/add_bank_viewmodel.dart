import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';


import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/views/kyc/component/successful.dart';
import 'package:onyxswap/widgets/base_view_model.dart';


import '../../../utils/locator.dart';
import '../../../utils/network_client.dart';
import '../../../utils/text.dart';
import '../../../widgets/flushbar.dart';

class AddBankViewModel extends BaseViewModel {
 
  final NetworkClient _networkClient = NetworkClient();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final NavigationService _navigationService = NavigationService.I;
  final LocalCache _localCache = locator<LocalCache>();
  // ignore: non_constant_identifier_names
  List<dynamic>? add_bank = [];
  List<dynamic>? listOfBank;
  late Map<String, dynamic> bankDetails;
  List<String> items = [
    'Select bank',
    'United Bank for Africa',
    'ZenithBank',
    'First Bank'
  ];
  String text = 'Select bank';
  String? mybank;
  bool checkDetails = false;
  bool checkbox = false;
  togglecheck() {
    checkbox = !checkbox;
    notifyListeners();
  }

  addBank2() async {
    try {
      isLoading = true;
      await _networkClient.post(ApiRoutes.addBank);
      listOfBank = _networkClient.data['entity'];
      notifyListeners();
      print(listOfBank);
      isLoading = false;
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "connection Time out",
            "Please check your internet connection and try again",
          ));
      isLoading = false;
    }
  }

  validateAccountNumber(
      {required String code, required String accountNumber}) async {
    try {
      isLoading = true;
     Map<String,dynamic> response= await _networkClient.post(ApiRoutes.validateBank,
          body: FormData.fromMap(
              {"accountnumber": accountNumber, "selectedBankCode": code}));
              if(response.containsKey('error')){
                  OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Error",
            response['error'],
          ));
      isLoading = false;
              }
              else{
                bankDetails = _networkClient.data['entity'];
      notifyListeners();
      print(bankDetails);
      isLoading = false;
      checkDetails = true;
      notifyListeners();
              }
      
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
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

  addAccountNumber(
      {required String accountnumber,
      required String code,
      required String bankname,
      required String accountName}) async {
    try {
      isLoading = true;
      String? userId = _localCache.getToken();
      await _networkClient.post(ApiRoutes.addAccountnumber,
          body: FormData.fromMap({
            'accountnumber': accountnumber,
            'selectedBankCode': code,
            'userId': userId,
            'userfullname': accountName,
            'userBankName': bankname
          }));
      // Navigator.pop(_navigationService.navigatorKey.currentContext!);
      Navigator.push(
          _navigationService.navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => Successful(
                    title: 'Bank Added successfully ',
                    // onTap: () => Navigator.popUntil( _navigationService.navigatorKey.currentContext!,
                    //     ModalRoute.withName(NavigatorRoutes.homeView)),
                  )));
      isLoading = false;
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
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

  getAddedbank(BuildContext context) async {
    try {
      isLoading = true;
      String? userId = _localCache.getToken();
      add_bank = await _networkClient.post(ApiRoutes.getBank,
          body: FormData.fromMap({'userId': userId}));
      notifyListeners();
      isLoading = false;
    } on DeadlineExceededException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "connection Time out",
            "Please check your internet connection and try again",
          ));
      isLoading = false;
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "No Internet connection",
            "Please check your internet connection and try again",
          ));
      isLoading = false;
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "Something Went wrong",
            "Please try again",
          ));
      isLoading = false;
    }
  }

  String getBankName(List myList) {
    String bankName = '';
    for (int i = 1; i < myList.length; i++) {
      bankName += myList[i] + ' ';
    }
    return bankName;
  }

  DropdownMenuItem<String> buildMenuItem(String item, String code) {
    return DropdownMenuItem<String>(
      child: AppText.body3L(
        item,
        color: kSecondaryColor,
      ),
      value: code + " " + item,
    );
  }

  // toggleCheck() {
  //   notifyListeners();
  //   checkDetails = true;
  //   notifyListeners();
  // }

  // AddBankViewModel() {
  //   getAddedbank();
  //   addBank2();
  // }
}
