import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onyxswap/core/constants/textstyle.dart';
import 'package:onyxswap/data/remote/auth/auth_repository.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/views/authentication/view%20model/signup_viewmodel.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../models/exceptions.dart';
import '../../utils/text.dart';
import '../../widgets/flushbar.dart';
import '../../widgets/next_circular_button.dart';

final signupViewModel =
    ChangeNotifierProvider.autoDispose((ref) => SignupViewModel());

class EmailOTP extends ConsumerWidget {
  const EmailOTP({Key? key, this.onNext}) : super(key: key);
  final Function()? onNext;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(signupViewModel);
    String pin = '';
    final emailOtpController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            AppText.heading1L(
              'Verify Email Address',
              centered: true,
              color: kSecondaryColor,
              multitext: true,
            ),
            const SizedBox(
              height: 14,
            ),
            AppText.body3L(
              'Code has been sent to ${AuthRepositoryImpl().sentemail}',
              color: kSecondaryColor,
              multitext: true,
            ),
            const SizedBox(
              height: 50,
            ),
            PinCodeTextField(
              obscureText: true,
              controller: emailOtpController,
              keyboardType: TextInputType.number,
              blinkWhenObscuring: true,
              blinkDuration: const Duration(seconds: 2),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textStyle: pinStyle.copyWith(color: kSecondaryColor),
              appContext: context,
              length: 4,
              onChanged: (value) {
                value = pin;
              },
              pinTheme: PinTheme(
                selectedColor: kSecondaryColor.withOpacity(0.62),
                activeColor: kSecondaryColor,
                inactiveColor: kSecondaryColor,
                shape: PinCodeFieldShape.underline,
              ),
            ),
            const SizedBox(
              height: 44,
            ),
            model.seconds==0?GestureDetector(
             onTap: () async {
                      print('pressedd');
                      await model.resendEmailCode(context);
                      model.resetTimer();
                    },
            child:AppText.body4PB('Resend Code')
           ): AppText.body4PB('Resend code in ${model.seconds}s'),
          ]),
          //Spacer(),
          GestureDetector(
            onTap: () async{
               if (model.formKey.currentState!.validate()) {
                try {
                  await model.emailOtp(emailOtpController.text);
                  onNext!();
                } on InvalidCredentialException {
                  OnyxFlushBar.showFailure(
                      context: context,
                      failure: UserDefinedException(
                          'Wrong OTP', 'Please try again or press resend OTP'));
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
                }
              }
            },
            child: const NextCircularButton(),
          )
          //const SizedBox(height: 138,),
          //const NextCircularButton()
        ],
      ),
    );
  }
}
