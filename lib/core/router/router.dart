import 'package:flutter/material.dart';
import 'package:onyxswap/core/constants/routeargument_key.dart';
import 'package:onyxswap/views/Security/component/setup_pin.dart';
import 'package:onyxswap/views/buy_and_sell/components/pinotp.dart';
import 'package:onyxswap/views/forget%20password/component/passwordsuccess.dart';
import 'package:onyxswap/views/forget%20password/component/reset_password.dart';
import 'package:onyxswap/views/forget%20password/component/verify_otp.dart';
import 'package:onyxswap/views/kyc/component/nationality.dart';
import 'package:onyxswap/views/kyc/component/successful.dart';
import 'package:onyxswap/views/pay_bills/components/electricity.dart';
import 'package:onyxswap/views/send_and_recieve/send_and_receive_view.dart';
import 'package:onyxswap/widgets/transaction_successful.dart';

import '../../views/Security/component/two_factor_authentication.dart';
import '../../views/Security/component/update_password.dart';
import '../../views/Security/security.dart';
import '../../views/authentication/email_otp.dart';
import '../../views/authentication/login_view.dart';
import '../../views/authentication/phone_otp.dart';
import '../../views/authentication/signup_view.dart';
import '../../views/banks/banks.dart';
import '../../views/buy_and_sell/buy_and_sell_view.dart';
import '../../views/forget password/forget_password.dart';
import '../../views/home/home_view.dart';
import '../../views/kyc/kyc_view.dart';
import '../../views/onboarding/onboarding_view.dart';
import '../../views/onboarding/splash_screen.dart';
import '../../views/pay_bills/buy_airtime_view.dart';
import '../../views/pay_bills/components/cable.dart';
import '../../views/preferences/preferences.dart';
import '../../views/referral/component/refferal_earning.dart';
import '../../views/referral/referral_view.dart';
import '../../views/wallets/naira_wallet.dart';
import '../../views/wallets/usdtwallet.dart';
import '../routes/routing_constants.dart';

class AppRouter {
  static PageRoute _getPageRoute({
    // ignore: unused_element
    required RouteSettings settings,
    required Widget viewToShow,
    // ignore: unused_element
    Object? arguments,
  }) {
    return MaterialPageRoute(
      builder: (context) => viewToShow,
      settings: settings,
    );
  }

  // //
  static Route<dynamic> onGenerateRoutes(RouteSettings routeSettings) {
    final Map<String, dynamic>? args =
        routeSettings.arguments as Map<String, dynamic>?;
    switch (routeSettings.name) {
      case NavigatorRoutes.onboardingView:
        return _getPageRoute(
            settings: routeSettings, viewToShow: const OnboardingView());

      case NavigatorRoutes.splashScreenView:
        return _getPageRoute(
            settings: routeSettings, viewToShow: const SplashScreen());
      case NavigatorRoutes.buy:
        return _getPageRoute(
            settings: routeSettings,
            viewToShow: BuyAndSellView(
              isBuyTapped: true,
            ));
      case NavigatorRoutes.recieve:
        return _getPageRoute(
            settings: routeSettings,
            viewToShow: SendAndReceiveView(
              isBuyTapped: false,
            ));
      case NavigatorRoutes.sell:
        return _getPageRoute(
            settings: routeSettings,
            viewToShow: BuyAndSellView(
              isBuyTapped: false,
            ));
      case NavigatorRoutes.send:
        return _getPageRoute(
            settings: routeSettings,
            viewToShow: SendAndReceiveView(
              isBuyTapped: true,
            ));
      case NavigatorRoutes.loginView:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const LoginView(),
        );
      case NavigatorRoutes.signUpView:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const SignUpView(),
        );
      case NavigatorRoutes.emailOtp:
        return _getPageRoute(
            settings: routeSettings, viewToShow: const EmailOTP());
      case NavigatorRoutes.phoneNoOtp:
        return _getPageRoute(
            settings: routeSettings, viewToShow: const PhoneNoOtp());

      // case NavigatorRoutes.wallet:
      //   return _getPageRoute(
      //       settings: routeSettings,
      //       viewToShow:  CoinsView(
      //         title: "Wallet",
      //       ));
      // case NavigatorRoutes.trends:
      //   return _getPageRoute(
      //     settings: routeSettings,
      //     viewToShow:  CoinsView(
      //       title: "Trends",
      //     ),
      //   );
      case NavigatorRoutes.payBills:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: Electricity(),
        );
      case NavigatorRoutes.buyAirtime:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: BuyAirtime(),
        );
      case NavigatorRoutes.homeView:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const HomeView(),
        );
      case NavigatorRoutes.kyc:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const Kyc(),
        );
      case NavigatorRoutes.addBank:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: AddBank(),
        );
      case NavigatorRoutes.nairaWallet:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const NairaWallet(),
        );
      case NavigatorRoutes.usdtWallet:
        String assets = args![RouteArgumentkeys.asset];
        String balance = args[RouteArgumentkeys.balance];
        String usdtBalance = args[RouteArgumentkeys.usdtBalance];
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: USDTwallet(
              asset: assets, balance: balance, usdtbalance: usdtBalance),
          //arguments: {}
        );

      case NavigatorRoutes.security:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const Security(),
        );
      case NavigatorRoutes.passwordSuccess:
        String heading = args![RouteArgumentkeys.heading];
        String subheading = args[RouteArgumentkeys.subheading];
        Function() onTap = args[RouteArgumentkeys.onTap];
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: PasswordSuccess(
            heading: heading,
            subHeading: subheading,
            onTap: onTap,
          ),
        );
      case NavigatorRoutes.transactionSuccess:
        String heading = args![RouteArgumentkeys.heading];
        String subheading = args[RouteArgumentkeys.subheading];
        //Function() onTap = args[RouteArgumentkeys.onTap];
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: TransactionSuccessful(
            heading: heading,
            subHeading: subheading,
          ),
        );
      case NavigatorRoutes.pinSetup:
        String heading = args![RouteArgumentkeys.heading];
        String subheading = args[RouteArgumentkeys.subheading];
        String title = args[RouteArgumentkeys.title];
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: PinSetup(
            heading: heading,
            subtitle: subheading,
            title: title,
          ),
        );
      case NavigatorRoutes.resetPassword:
        String phonenumber = args![RouteArgumentkeys.phonenumber];
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: ResetPassword(
            phonenumber: phonenumber,
          ),
        );
      case NavigatorRoutes.verifyOtp:
        String phonenumber = args![RouteArgumentkeys.phonenumber];
        String referenceId = args[RouteArgumentkeys.referenceId];
        String type = args[RouteArgumentkeys.type];
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: VerifyPasswordOtp(
            phonenumber: phonenumber,
            referenceid: referenceId,
            type: type,
          ),
        );
      case NavigatorRoutes.nationality:
        String type = args![RouteArgumentkeys.type];
        String hint = args[RouteArgumentkeys.hint];
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: Nationality(
            type: type,
            hint: hint,
          ),
        );
      case NavigatorRoutes.success:
        String title = args![RouteArgumentkeys.heading];
        String caption = args[RouteArgumentkeys.subheading];
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: Successful(
            title: title,
            caption: caption,
          ),
        );
      // case NavigatorRoutes.pinOtp:
      //   String type = args![RouteArgumentkeys.type];
      //   String referenceId = args[RouteArgumentkeys.referenceId];
      //   String assetamount = args[RouteArgumentkeys.assetamount];
      //   String amount = args[RouteArgumentkeys.amount];
      //   String userid = args[RouteArgumentkeys.userid];
      //   String currentAsset = args[RouteArgumentkeys.asset];
      //   return _getPageRoute(
      //     settings: routeSettings,
      //     viewToShow: PinOtp(
      //       type: type,
      //       referenceid: referenceId,
      //       amount: amount,
      //       assetamount: assetamount,
      //       userid: userid,
      //       currentAsset: currentAsset,
      //     ),
      //   );
      case NavigatorRoutes.preferences:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const PreferenceView(),
        );
      case NavigatorRoutes.refer:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const ReferAndEarn(),
        );
      case NavigatorRoutes.refferalEarning:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const RefferalEarning(),
        );
      case NavigatorRoutes.updatePassword:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: UpdatePassword(),
        );
      // case NavigatorRoutes.pinSetup:
      //   return _getPageRoute(
      //     settings: routeSettings,
      //     viewToShow: const PinSetup(),
      //   );
      case NavigatorRoutes.twoFactorAuthenticaton:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const TwoFactorAuthentication(),
        );
      case NavigatorRoutes.forgetPassword:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const ForgetPassword(),
        );
      case NavigatorRoutes.cable:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: Cable(),
        );
      // case NavigatorRoutes.success:
      //   return _getPageRoute(
      //     settings: routeSettings,
      //     viewToShow: const TransactionSuccessful(),
      //   );
      // case NavigatorRoutes.bvn:
      //   return _getPageRoute(
      //     settings: routeSettings,
      //     viewToShow:  Nationality(),
      //   );
      // case NavigatorRoutes.nin:
      //   return _getPageRoute(
      //     settings: routeSettings,
      //     viewToShow: const ForgetPassword(),
      //   );

      default:
        return _getPageRoute(
          settings: routeSettings,
          viewToShow: const Center(),
        );
    }
  }
}
