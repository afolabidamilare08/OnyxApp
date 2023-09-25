import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/models/failure.dart';
import 'package:onyxswap/models/view_model_states/view_model_state.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/views/kyc/component/nationality.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/flushbar.dart';

import '../../../core/routes/routing_constants.dart';
import '../../../utils/locator.dart';

class WalletViewModel extends BaseViewModel {
  final NetworkClient _networkClient = NetworkClient();
  final StreamController streamController = StreamController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  String? btcBalance;
  String? ethBalance;
  String? ltcBalance;
  late final Timer timer;
  List nairabalances = [];
  // final NavigationService _navigationService =NavigationService.I
  String? fullname;
  List icons = [
    SvgPicture.asset(
      "assets/svgs/naira.svg",
      height: 16,
      width: 70,
    ),
    SvgPicture.asset(
      "assets/svgs/bitcoin.svg",
      height: 16,
      width: 70,
    ),
    const Icon(
      NyxIcons.usdt,
      color: kSuccessColor,
    ),
    const Icon(
      NyxIcons.busd,
      color: kSuccessColor,
    )
  ];
  List<String> title = ['Naira', 'BTC', 'USDT', 'BUSD'];
  List<String> values = ['Naira', 'BTC', 'USDT_TRON', 'BUSD'];
  List<String> sign = ['NGN', 'btc', 'usdt', 'busd'];
  List coins = ['Bitcoin', 'USDT', 'BUSD'];
  List symbols = ['BTC', 'USDT', 'BUSD'];
  List<String> walletBalance = [];

  List gottenBalance = [];
  String? nairabalance;
  List icon = [
    SvgPicture.asset(
      "assets/svgs/bitcoin.svg",
      height: 16,
      width: 70,
    ),
    const Icon(
      NyxIcons.usdt,
      color: kSuccessColor,
    ),
    const Icon(
      NyxIcons.busd,
      color: kSuccessColor,
    )
  ];
  String? btcPrice;
  String? usdtPrice;
  String? usdcPrice;
  List<String> prices = [];
  get streamgetter => streamController.close();
  getFullname() {
    fullname = '${_localCache.getFromLocalCache('firstname')}';
  }

  fetchMarketPrices(BuildContext context) async {
    try {
      // isLoading = true;
      await _networkClient.post(ApiRoutes.fetchMarketPrice,
          body: FormData.fromMap({'fetchmarket': 1}));
      Map<String, dynamic> result = _networkClient.data['data'];
      if (!streamController.isClosed) {
        streamController.sink.add(result);
      }
      btcPrice = result['BTC'];
      usdtPrice = result['USDT_TRON'];
      usdcPrice = result['BUSD'];
      prices = [btcPrice!, usdtPrice!, usdcPrice!];
      walletBalance = [
        // (double.tryParse(gottenBalance[0])! / double.tryParse(usdcPrice!)!)
        //     .toString(),
        '',
        btcBalance = gottenBalance.isNotEmpty
            ? '\$${(double.tryParse(btcPrice!)! * double.tryParse(gottenBalance[1])!).toStringAsFixed(2)}'
            : '\$0.00',
        ethBalance = gottenBalance.isNotEmpty
            ? '\$${(double.tryParse(usdtPrice!)! * double.tryParse(gottenBalance[2])!).toStringAsFixed(2)}'
            : '\$0.00',
        ltcBalance = gottenBalance.isNotEmpty
            ? '\$${(double.tryParse(usdcPrice!)! * double.tryParse(gottenBalance[3])!).toStringAsFixed(2)}'
            : '\$0.00'
      ];
      if (!isDisposed) {
        notifyListeners();
      }
      //await convertTonaira();
      print(nairabalances);
      await _localCache.saveToLocalCache(key: 'prices', value: prices);
      await _localCache.saveToLocalCache(
          key: 'walletbalance', value: walletBalance);
      if (!isDisposed) {
        notifyListeners();
      }

      isLoading = false;

      print(_localCache.getFromLocalCache('prices'));
    } on NoInternetConnectionException {
      // OnyxFlushBar.showFailure(
      //     context: scaffoldKey.currentState!.context,
      //     failure: UserDefinedException(
      //         'No internet connection', 'Prices are not updated'));
      _localCache.getFromLocalCache('prices');
      _localCache.getFromLocalCache('walletbalance');
      if (!isDisposed) {
        notifyListeners();
      }
      isLoading = false;
    } on InternalServerErrorException {
      _localCache.getFromLocalCache('prices');
      _localCache.getFromLocalCache('walletbalance');

      if (!isDisposed) {
        notifyListeners();
      }
      isLoading = false;
      // OnyxFlushBar.showFailure(
      //     context: scaffoldKey.currentState!.context,
      //     failure: UserDefinedException(
      //         'No internet connection', 'Prices are not updated'));
    } on DeadlineExceededException {
      _localCache.getFromLocalCache('prices');
      _localCache.getFromLocalCache('walletbalance');
      // OnyxFlushBar.showFailure(
      //     context: scaffoldKey.currentContext ??
      //         _navigationService.navigatorKey.currentContext!,
      //     failure: UserDefinedException(
      //         'Connection timeout', 'Please Check your internet connect '));

      if (!isDisposed) {
        notifyListeners();
      }
      isLoading = false;
    } on Failure {
      // OnyxFlushBar.showFailure(
      //     context: scaffoldKey.currentState!.context,
      //     failure: UserDefinedException(
      //         'No internet connection', 'Prices are not updated'));
      _localCache.getFromLocalCache('prices');
      _localCache.getFromLocalCache('walletbalance');
      if (!isDisposed) {
        notifyListeners();
      }
      isLoading = false;
    } on DioError {
      _localCache.getFromLocalCache('prices');
      _localCache.getFromLocalCache('walletbalance');
      isLoading = false;
    }
  }

  convertTonaira() async {
    try {
      // isLoading = true;
      if (walletBalance.isNotEmpty) {
        for (int i = 1; i < walletBalance.length; i++) {
          //print(title[i]);
          Map<String, dynamic> response = await _networkClient.post(
              ApiRoutes.nairaconversion,
              body: FormData.fromMap({'amount': walletBalance[i]}));
          if (response.containsKey('error')) {
            nairabalances.add('₦0.00');
            if (!isDisposed) {
              notifyListeners();
            }
          } else {
            nairabalances.add(
                '₦${double.tryParse(response['result'])!.toStringAsFixed(2)}');
            if (!isDisposed) {
              notifyListeners();
            }
            print(nairabalances);
          }
        }
      }
    } on Failure {
      OnyxFlushBar.showFailure(
          context: scaffoldKey.currentContext ??
              _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
              'error', 'Something went wrong please try again'));
    }
  }

  createAssets() async {
    try {
      isLoading = true;

      String? userid = _localCache.getToken();
      print(userid);
      // await _networkClient.post(ApiRoutes.dashboard,
      //     body: FormData.fromMap({
      //       'userid': userid,
      //     }));
      for (int i = 1; i < title.length; i++) {
        changeState(const ViewModelState.busy());
        isLoading = true;
       var response= await _networkClient.post(ApiRoutes.dashboard,
            body: FormData.fromMap({'userid': userid, 'asset': values[i]}));
            print(response);
      }
      
      changeState(const ViewModelState.idle());
      isLoading = false;
    } on DeadlineExceededException {
      _localCache.getFromLocalCache('prices');
      if (!isDisposed) {
        notifyListeners();
      }
      changeState(const ViewModelState.idle());
      isLoading = false;
    } on InternalServerErrorException {
      _localCache.getFromLocalCache('prices');
      if (!isDisposed) {
        notifyListeners();
      }
      changeState(const ViewModelState.idle());
      isLoading = false;
    } on NoInternetConnectionException {
      _localCache.getFromLocalCache('prices');
      if (!isDisposed) {
        notifyListeners();
      }
      changeState(const ViewModelState.idle());
      isLoading = false;
    }on Failure{
         _localCache.getFromLocalCache('prices');
      if (!isDisposed) {
        notifyListeners();
      }
      changeState(const ViewModelState.idle());
      isLoading = false;
    }
  }

  getBalance() async {
    print('balance');
    try {
      List balance = [];
      String? userid = _localCache.getToken();
      print(userid);
      isLoading = true;
      await fetchNairawallet();
      balance.add(nairabalance ?? '0');
      for (int i = 1; i < title.length; i++) {
        await _networkClient.post(ApiRoutes.checkassetbalance,
            body: FormData.fromMap({'userid': userid, 'asset': values[i]}));
        print(1);
        var response = _networkClient.data['balance'];
        response == '0.0'
            ? balance.add(response)
            : balance
                .add(double.tryParse(response.toString())!.toStringAsFixed(7));

        if (!isDisposed) {
          notifyListeners();
        }
      }
      gottenBalance = balance;
      await _localCache.saveToLocalCache(key: 'balances', value: gottenBalance);

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

  createNairaWallet(BuildContext context) async {
    try {
      String? userid = _localCache.getToken();
      print(userid);
      isLoading = true;
      try {
        isLoading = true;

        await _networkClient.post(ApiRoutes.checkBvn,
            body: FormData.fromMap({'userid': userid}));
        Map<String, dynamic> result = _networkClient.data;
        isLoading = false;
        if (result['status'] == 403) {
          // OnyxFlushBar.showFailure(
          //     context: _navigationService.navigatorKey.currentContext!,
          //     failure: UserDefinedException('${result['error']}',
          //         'Please verify your BVN to create Naira wallet '));
          Navigator.push(
              _navigationService.navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (context) =>
                      Nationality(type: 'BVN', hint: 'BVN Number')));
          isLoading = false;
        } else {
          isLoading = true;
          await _networkClient.post(ApiRoutes.createnairawallet,
              body: FormData.fromMap({'userid': userid}));
          Map<String, dynamic> response = _networkClient.data;
          if (response['status'] == 200) {
            OnyxFlushBar.showSuccess(
                context: context, message: 'Naira wallet created successfully');
            _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
          } else if (response['status'] == 404) {
            _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
          }
          isLoading = false;
        }
      } on DeadlineExceededException {
        OnyxFlushBar.showFailure(
            context: scaffoldKey.currentContext ??
                _navigationService.navigatorKey.currentContext!,
            failure: UserDefinedException(
                'Connection timeout', 'Please Check your internet connect '));
        nairabalance = _localCache.getFromLocalCache('nairabalance').toString();
        isLoading = false;
      }
    } on InvalidCredentialException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
              'error', 'Please verify your BVN to create Naira wallet '));
      isLoading = false;
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
              'error', 'Something went wrong please try again'));
      isLoading = false;
    } on UnauthorizedException {
      _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
      isLoading = false;
    } on NotFoundException {
      OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
              'error', 'Something went wrong please try again'));
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: scaffoldKey.currentContext ??
              _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
              'Connection timeout', 'Please Check your internet connect '));
      isLoading = false;
    }
  }

  fetchNairawallet() async {
    try {
      String? userid = _localCache.getToken();
      isLoading = true;
      await _networkClient.post(ApiRoutes.fetchNairaWallet,
          body: FormData.fromMap({'userid': userid}));
      Map<String, dynamic> result = _networkClient.data;
      if (result['status'] == 404) {
        nairabalance = result['balance'].toString();
      } else if (result['status'] == 200) {
        nairabalance = result['nairawalletbalance'].toStringAsFixed(2);
        await _localCache.saveToLocalCache(
            key: 'nairabalance', value: nairabalance);
        if (!isDisposed) {
          notifyListeners();
        }
      } else {
        // nairabalance= _localCache.getFromLocalCache('nairabalance').toString();
        nairabalance = result['balance'].toString();
        OnyxFlushBar.showFailure(
            context: scaffoldKey.currentContext ??
                _navigationService.navigatorKey.currentContext!,
            failure: UserDefinedException(
                'Error', 'Please register your BVN to create naira wallet'));
      }
      isLoading = false;
    } on DeadlineExceededException {
      nairabalance = _localCache.getFromLocalCache('nairabalance').toString();
      OnyxFlushBar.showFailure(
          context: scaffoldKey.currentContext ??
              _navigationService.navigatorKey.currentContext ??
              _navigationService.navigatorKey.currentState!.context,
          failure: UserDefinedException(
              'Connection timeout', 'Please Check your internet connect '));

      isLoading = false;
    } on InternalServerErrorException {
      OnyxFlushBar.showFailure(
          context: scaffoldKey.currentContext ??
              _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
              'Connection timeout', 'Please Check your internet connect '));
      nairabalance = _localCache.getFromLocalCache('nairabalance').toString();
      isLoading = false;
    } on NoInternetConnectionException {
      OnyxFlushBar.showFailure(
          context: scaffoldKey.currentContext ??
              _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
              'Connection timeout', 'Please Check your internet connect '));
      nairabalance = _localCache.getFromLocalCache('nairabalance').toString();
      isLoading = false;
    } on UnauthorizedException {
      _navigationService.navigateTo(NavigatorRoutes.nairaWallet);
    }
  }

  bool mounted = false;
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  futures() async {
    await Future.wait([
      fetchNairawallet(),
      getFullname(),
      getBalance(),
      fetchMarketPrices(scaffoldKey.currentContext ??
          _navigationService.navigatorKey.currentContext!),
      createAssets(),
    ] as Iterable<Future<dynamic>>);
  }

  WalletViewModel() {
    isLoading = true;
    fetchNairawallet();
    createAssets();
    getFullname();
    getBalance();
    fetchMarketPrices(scaffoldKey.currentContext ??
        _navigationService.navigatorKey.currentContext!);
    isLoading = false;
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_localCache.getToken() != null || !isDisposed) {
        fetchMarketPrices(scaffoldKey.currentContext ??
            _navigationService.navigatorKey.currentContext!);
      } else {
        timer.cancel();
      }
    });
  }
}
