import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/core/constants/custom_icons.dart';

import 'package:onyxswap/core/constants/textstyle.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/models/failure.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/validators.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utils/text.dart';
import '../../widgets/flushbar.dart';
import '../../widgets/next_circular_button.dart';
import 'view model/signup_viewmodel.dart';

final signupViewModel = ChangeNotifierProvider((ref) => SignupViewModel());

class PhoneNoOtp extends ConsumerStatefulWidget {
  const PhoneNoOtp({Key? key, this.onNext, this.onBack}) : super(key: key);
  final Function()? onNext;
  final Function()? onBack;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhoneNoOtpState();
}

TextEditingController phoneOtpController = TextEditingController();

class _PhoneNoOtpState extends ConsumerState<PhoneNoOtp> {
  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 2), ref.read(signupViewModel).startTimer());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(signupViewModel);
    String pin = '';

    return LoaderPage(
      loading: model.isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 42.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: widget.onBack,
                      child: Icon(
                        NyxIcons.arrow_back,
                        color: kSecondaryColor,
                      )),
                  AppText.heading1L(
                    'Verify Phone Number',
                    centered: true,
                    color: kSecondaryColor,
                    multitext: true,
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              AppText.body3L(
                'Code has been sent to Your phone number',
                color: kSecondaryColor,
                multitext: true,
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: model.formKey,
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                child: PinCodeTextField(
                  autoDisposeControllers: false,
                  controller: phoneOtpController,
                  validator: TextFieldValidators.otp,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  blinkWhenObscuring: false,
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
              ),
              const SizedBox(
                height: 44,
              ),
              model.seconds == 0
                  ? GestureDetector(
                      onTap: () async {
                        print('pressedd');
                        await model.resendCode(context);
                        //model.resetTimer();
                      },
                      child: AppText.body4PB('Resend Code'))
                  : AppText.body4PB('Resend code in ${model.seconds}s'),
            ]),
            GestureDetector(
              onTap: () async {
                if (model.formKey.currentState!.validate()) {
                  try {
                    model.isLoading = true;
                    var response =
                        await model.phoneOtp(phoneOtpController.text);
                    if (response.containsKey('error')) {
                      //print(response.otpresponse.entity);
                      // OnyxFlushBar.showFailure(
                      //   context: context,
                      //   failure: UserDefinedException(
                      //     "Wrong Otp",
                      //     "Incorrect OTP",
                      //   ),
                      // );
                      model.isLoading = false;
                      phoneOtpController.clear();
                    } else {
                      //  print(response.otpresponse.entity);
                      widget.onNext!();
                      model.isLoading = false;
                    }
                  } on Failure catch (e) {
                  OnyxFlushBar.showError(title: e.title, message: e.message);
                }
                model.isLoading = false;
                }
              },
              child: const NextCircularButton(),
            )
            // const SizedBox(height: 138,),
            //const NextCircularButton()
          ],
        ),
      ),
    );
  }
}
