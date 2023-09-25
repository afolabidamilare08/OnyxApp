// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onyxswap/views/forget%20password/component/reset_password.dart';
import 'package:onyxswap/views/forget%20password/viewmodel/forget_viewmodel.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/loaderpage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/constants/textstyle.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';

final _forgetpassword =
    ChangeNotifierProvider.autoDispose((ref) => ForgetPasswordViewmodel());

class VerifyPasswordOtp extends ConsumerStatefulWidget {
  const VerifyPasswordOtp(
      {Key? key,
      required this.type,
      required this.referenceid,
      required this.phonenumber})
      : super(key: key);
  final String type;
  final String referenceid;
  final String phonenumber;
  @override
  ConsumerState<VerifyPasswordOtp> createState() => _VerifyPasswordOtpState();
}

//extEditingController phoneotpController = TextEditingController();
TextEditingController pin = TextEditingController();

class _VerifyPasswordOtpState extends ConsumerState<VerifyPasswordOtp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, ref.read(_forgetpassword).startTimer());
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var model = ref.watch(_forgetpassword);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LoaderPage(
          loading: model.isLoading,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: kSecondaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      width: 206,
                      child: AppText.heading1L(
                        'We just sent you a recovery code',
                        multitext: true,
                        color: kSecondaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AppText.body2L(
                      'Code has been sent to ${widget.type}',
                      color: kSecondaryColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                PinCodeTextField(
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  autoDisposeControllers: false,
                  blinkWhenObscuring: false,
                  blinkDuration: const Duration(seconds: 2),
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  textStyle: pinStyle.copyWith(color: kSecondaryColor),
                  appContext: context,
                  controller: pin,
                  length: 4,
                  onChanged: (value) {
                    // var pin;
                    // value = pin;
                  },
                  pinTheme: PinTheme(
                    selectedColor: kSecondaryColor.withOpacity(0.62),
                    activeColor: kSecondaryColor,
                    inactiveColor: kSecondaryColor,
                    shape: PinCodeFieldShape.underline,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    model.seconds == 0
                        ? GestureDetector(
                            onTap: () async {
                              print(widget.phonenumber);
                             model.resendOtp(
                                  widget.phonenumber, context);
                              //model.resetTimer();
                            },
                            child: AppText.body4PB('Resend Code'))
                        : AppText.body4PB('Resend code in ${model.seconds}s'),
                    SizedBox(
                      width: 40,
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                AppButton(
                    title: 'Verify',
                    onTap: () {
                      print(widget.referenceid);
                      print(pin.text);
                      model.onVerifyTap(
                          pin.text, widget.referenceid, widget.phonenumber);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
