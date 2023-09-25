import 'package:flutter/material.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/views/onboarding/components/onboarding_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/app_colors.dart';
import '../../widgets/app_button.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingVewState();
}

NavigationService _navigationService = NavigationService.I;
PageController pageController = PageController();

class _OnboardingVewState extends State<OnboardingView> {
  @override
  void didChangeDependencies() {
    FocusScope.of(context).unfocus();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 94, top: 20),
          child: Column(children: [
            SmoothPageIndicator(
              controller: pageController,
              count: 4,
              effect: SlideEffect(
                  dotHeight: 8,
                  activeDotColor: Colors.white,
                  dotWidth: MediaQuery.of(context).size.width / 5,
                  dotColor: kAccentColor,
                  spacing: MediaQuery.of(context).size.width / 25),
            ),
            Expanded(
              // height: MediaQuery.of(context).size.height < 700
              //     ? MediaQuery.of(context).size.height / 1.5
              //     : MediaQuery.of(context).size.height / 1.75,
              child: PageView(
                controller: pageController,
                children: const [
                  OnboardingWidget(
                      image: 'firstpage.svg',
                      text:
                          'Buy and sell cryptocurrencies from anywhere in the World',
                      title: 'Buy and Sell with Speed! '),
                  OnboardingWidget(
                      image: 'secondpage.svg',
                      text:
                          'Pay all your utility bills at the comfort of your mobile',
                      title: 'Pay Utility bills with ease '),
                  OnboardingWidget(
                      image: 'thirdpage.svg',
                      text: 'Withdraw to any local account with ease',
                      title: ' Universal Withdrawal   '),
                  OnboardingWidget(
                      image: 'fourthpage.svg',
                      text: "Let's set you up",
                      title: 'Are you ready to gig it? '),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  AppButton(
                    onTap: () => _navigationService
                        .navigateTo(NavigatorRoutes.signUpView),
                    title: 'Sign up',
                    height: MediaQuery.of(context).size.height < 400
                        ? MediaQuery.of(context).size.height / 8
                        : 51,
                    textColor: kSecondaryColor,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  AppButton(
                    onTap: () => _navigationService
                        .navigateTo(NavigatorRoutes.loginView),
                    title: 'Login',
                    height: MediaQuery.of(context).size.height < 400
                        ? MediaQuery.of(context).size.height / 8
                        : 51,
                    textColor: kSecondaryColor,
                    backgroundColor: AppColors.backgroundColor,
                    showBorder: true,
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
