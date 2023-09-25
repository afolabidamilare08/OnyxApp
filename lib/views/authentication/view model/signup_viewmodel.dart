import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onyxswap/views/authentication/models/signup_model.dart';

import '../../../core/routes/routing_constants.dart';
import '../../../core/services/navigation_service.dart';
import '../../../data/remote/auth/auth_interface.dart';
import '../../../data/remote/auth/auth_service.dart';
import '../../../models/exceptions.dart';
import '../../../models/failure.dart';
import '../../../models/push_notification_model.dart';
import '../../../utils/locator.dart';
import '../../../widgets/base_view_model.dart';
import '../../../widgets/flushbar.dart';
import '../components/almost_there.dart';
import '../components/country_flag.dart';
import '../components/full_name.dart';
import '../components/phone_no.dart';
import '../components/preferred_languages.dart';
import '../phone_otp.dart';

enum PasswordProgress { none, above8, specialLetter, upperLowerCase }

class SignupViewModel extends BaseViewModel {
  bool _disposed = false;
  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  final NavigationService _navigationService = NavigationService.I;
  final AuthService authService = locator<AuthService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  LocalNotification localNotification = LocalNotification();

  PasswordProgress _passwordProgress = PasswordProgress.none;
  PasswordProgress get passwordProgress => _passwordProgress;
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;
  String? _language = 'ENG';
  String? get language2 => _language;
  List<String> countries = ['NGN', 'GHA', 'SA'];
  List<String> countryvalue = ['Nigeria', 'Ghana', 'Southafrica'];
  selectLanguage(String e) {
    _language = e;
    notifyListeners();
  }

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

  String? _country = 'Nigeria';
  String? get country2 => _country;
  selectCountry(String e) {
    _country = e;
    notifyListeners();
  }

  List<DropdownMenuItem<String>> buildLanguagesDropDown() {
    return languages
        .map(
          (e) => DropdownMenuItem(
            child: Row(
              children: [
                Text(e),
              ],
            ),
            value: e,
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<String>> buildCountry(String value) {
    return countries
        .map(
          (e) => DropdownMenuItem(
            child: Row(
              children: [
                Text(e),
              ],
            ),
            value: value,
          ),
        )
        .toList();
  }

  late List<Widget> pages = [
    PreferredLanguages(
      onBack: () =>
          Navigator.pop(_navigationService.navigatorKey.currentState!.context),
      //_navigationService.navigateToReplace(NavigatorRoutes.onboardingView),
      onNext: () => onNext(),
    ),
    CountryFlag(
      onBack: () => previousPage(),
      onNext: () => onNext(),
    ),
    Fullname(
      onBack: () => previousPage(),
      onNext: () => onNext(),
    ),
    PhoneNumber(
      onBack: () => previousPage(),
      onNext: () => onNext(),
    ),
    PhoneNoOtp(
      onNext: () => onNext(),
      onBack: () => previousPage(),
    ),
    AlmostTherePage(
      onNext: () => onNext(),
      onBack: () => previousPage(),
    ),
    // EmailOTP(
    //   onNext: () => onNext(),
    // ),
  ];
  int _currentPage = 0;
  int get currentPage => _currentPage;
  PageController controller = PageController(initialPage: 0);
  int index = 0;
  //String language = 'ENG';
  List<String> languages = [
    'ENG',
    'IGBO',
    'HAUSA',
    'YORUBA',
  ];

  setCurrentPage(int val) {
    index = val;
    notifyListeners();
  }

  setPreviousPage() {
    _currentPage -= 1;
    if (controller.hasClients) {
      controller.jumpToPage(_currentPage);
    }
    notifyListeners();
  }

  previousPage() {
    controller.previousPage(
      duration: const Duration(seconds: 1),
      curve: Curves.ease,
    );
    notifyListeners();
  }

  onNext() async {
    if (index == 5) {
      _navigationService.navigateTo(NavigatorRoutes.loginView);
      LocalNotification.showNotification(
          title: 'Welcome to OnyxSwap', body: 'Your Sign up was successful');
    } else {
      await controller.nextPage(
          duration: const Duration(seconds: 1), curve: Curves.ease);
    }
  }

  onPasswordChanged(String currentPassword) {
    _passwordProgress = PasswordProgress.none;
    //geater than 8
    if (currentPassword.length >= 8) {
      _passwordProgress = PasswordProgress.above8;
      // has special character
      if (currentPassword.contains(RegExp(r'(\W|_)'))) {
        _passwordProgress = PasswordProgress.specialLetter;
        //has upper and lower case
        if (currentPassword.contains(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])+'))) {
          _passwordProgress = PasswordProgress.upperLowerCase;
        }
      }
    }
    notifyListeners();
  }

  Future<void> language(String language) async {
    print('checking');
    await authService.language(language);
  }

  Future<void> country(String country) async {
    print('checking');
    await authService.country(country);
  }

  Future<void> fullname(
      {required String firstname, required String lastname}) async {
    print(lastname);
    await authService.fullName(firstname: firstname, lastname: lastname);
    // await _localCache.saveToLocalCache(key: 'fullname', value: fullname);
  }

  Future phoneumber(String phonenumber) async {
    print('checking');

    final response = await authService.phonenumber(phonenumber);
    return response;
  }

  Future<Map<String, dynamic>> phoneOtp(String otp) async {
    print('checking');
    Map<String, dynamic> response =
        await authService.phonenumberVerification(otp);
    print(response);
    return response;
  }

  Future<Map<String, dynamic>> info(
      {required String email,
      required String dob,
      required String password,
      required String fbToken}) async {
    print('checking');
    Map<String, dynamic> response = await authService.info(
        email: email, dob: dob, password: password, fbToken: fbToken);
    return response;
  }

  Future<void> emailOtp(String otp) async {
    print('checking');
    await authService.emailVerification(otp);
  }

  Future resendCode(BuildContext context) async {
    try {
      await authService.resendPhoneVerificationCode();
      print('checked');
      OnyxFlushBar.showSuccess(
          context: context, message: 'Otp sent succesfully');
      resetTimer();
    } on Failure catch (e) {
                  OnyxFlushBar.showError(title: e.title, message: e.message);
                }
    isLoading = false;
  }

  Future resendEmailCode(BuildContext context) async {
    try {
      await authService.resendEmailVerificationCode();
      print('checked');
      OnyxFlushBar.showSuccess(
          context: context, message: 'Otp sent succesfully');
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

  SignupViewModel() {
    localNotification.initialise();
    listenToNotification();
  }
  void listenToNotification() => localNotification.onNotificationClick.stream
      .listen(onNotificationListener);

  void onNotificationListener(NotificationResponse? event) {
    _navigationService.navigateTo(NavigatorRoutes.loginView);
  }
}
