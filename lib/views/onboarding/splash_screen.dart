import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/onboarding/viewmodel/splash_screen_viewmodel.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../models/push_notification_model.dart';



final _splashScreenViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => SplashScreenViewmodel());

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
 

  @override
  void didChangeDependencies() {
    FocusScope.of(context).unfocus();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2),
        ref.read(_splashScreenViewmodel).checkLoginStatus);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 80.0,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  const Center(
                    child: Image(
                      image: AssetImage('assets/splash.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 75,
                  ),
                  SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                          child: Lottie.asset("assets/lotties/loader.json")))
                ],
              ),
            ),
          ),
        ));
  }
}
