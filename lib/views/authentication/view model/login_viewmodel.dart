import 'package:flutter/material.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';

import 'package:onyxswap/data/remote/auth/auth_interface.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/models/failure.dart';
import 'package:onyxswap/models/login_response.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/flushbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/routes/routing_constants.dart';
import '../../../core/services/navigation_service.dart';
import '../../../utils/locator.dart';

class LoginViewModel extends BaseViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService _authService = locator<AuthService>();
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  bool isSuspended = false;
  gotoSignup() => _navigationService.navigateTo(NavigatorRoutes.signUpView);
  gotoForgetpassword() =>
      _navigationService.navigateTo(NavigatorRoutes.forgetPassword);
  login({required String phoneNumber, required String password}) async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading = true;
        String? fbToken = _localCache.getFromLocalCache('firebaseToken').toString();
        final response = await _authService.login(
            phoneNumber: phoneNumber, password: password,fbToken: fbToken);

        isLoading = false;
      } on NotFoundException {
        // print("user not found");
        OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Login Failed",
            "Sorry, this account does not exist!.",
          ),
        );

        isLoading = false;
      } on InvalidCredentialException {
        // print("user not found");
        OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Login Failed",
            "Incorrect password",
          ),
        );

        isLoading = false;
      } on UnauthorizedException {
        isSuspended = true;
        OnyxFlushBar.showError(
            title: 'Suspended',
            message: 'Your account has been suspended. Please contact suppor');
        isLoading = false;
      } on Failure catch (failure) {
        OnyxFlushBar.showFailure(
            context: _navigationService.navigatorKey.currentContext!,
            failure: failure);
        hasError = true;
        isLoading = false;
      }
    } else {
      print('error');
    }
  }

  launchWhatsapp() async {
    if (await canLaunchUrl(
        Uri.parse('https://wa.me/23408172247276?text=Getting%20started'))) {
      await launchUrl(
          Uri.parse('https://wa.me/23408172247276?text=Getting%20started'),
          mode: LaunchMode.externalApplication);
    }
  }

  launchEmail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

// ···
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'hello@onyxswap.africa',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );
    // if (Platform.isAndroid) {
    //   PathProviderAndroid.registerWith();
    // }

    await launchUrl(Uri.parse('mailto:hello@onyxswap.africa'));
  }
}
