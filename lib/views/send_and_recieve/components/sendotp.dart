import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/send_and_recieve/viewmodel/send_viewmodel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/constants/custom_icons.dart';
import '../../../core/constants/textstyle.dart';
import '../../../core/routes/routing_constants.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../../../utils/validators.dart';
import '../../../widgets/background_widget.dart';
import '../../../widgets/next_circular_button.dart';
import '../../buy_and_sell/components/loader.dart';

final _sendviewModel = ChangeNotifierProvider.autoDispose(
  (ref) => SendAndRecieveViewmodel(),
);

class PinOtp extends ConsumerStatefulWidget {
  const PinOtp({
    Key? key,
    required this.amount,
    required this.reciever,
    required this.referenceid,
    required this.userid,
    required this.type,
  }) : super(key: key);
  final String reciever;
  final String amount;
  final String? userid;
  final String type;
  final String? referenceid;

  @override
  ConsumerState<PinOtp> createState() => _PinOtpState();
}

TextEditingController phoneotpController = TextEditingController();

class _PinOtpState extends ConsumerState<PinOtp> {
  @override
  void initState() {
    super.initState();
    phoneotpController.text = '';
    Future.delayed(Duration.zero, ref.read(_sendviewModel).startTimer());
    // } else {
    //   //ref.read(_buyViewmodel).resetTimer();
    // }
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(_sendviewModel);
    String pin = '';

    return BackgroundWidget(
        flexibleSpace: MediaQuery.of(context).size.height < 700 ? 30 : 190,
        buyAndSell: false,
        sendAndRecieve: false,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // phoneotpController.dispose();
                            // model.resetTimer();
                            model.timer!.cancel();
                            Navigator.popUntil(context,
                                ModalRoute.withName(NavigatorRoutes.homeView));
                          },
                          child: Icon(
                            NyxIcons.arrow_back,
                            color: kSecondaryColor,
                            size: 20,
                          ),
                        ),
                        AppText.heading1L(
                          'Verify Phone Number',
                          centered: true,
                          color: kSecondaryColor,
                          multitext: true,
                        ),
                        SizedBox(
                          width: 2,
                        )
                      ]),
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
                      controller: phoneotpController,
                      validator: TextFieldValidators.otp,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      blinkWhenObscuring: false,
                      blinkDuration: const Duration(seconds: 2),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      autoDisposeControllers: false,
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
                  model.isLoading
                      ? const PinLoader()
                      : const SizedBox(
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
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                GestureDetector(
                  onTap: () {
                    model.onPinTap(
                        referenceids: widget.referenceid!,
                        pin: phoneotpController.text,
                        userid: widget.userid!,
                        amount: widget.amount,
                        reciever: widget.reciever,
                        context: context,
                        type: widget.type,
                        mounted: mounted);
                    phoneotpController.clear();
                  },
                  child: const NextCircularButton(),
                )
                // const SizedBox(height: 138,),
                //const NextCircularButton()
              ],
            ),
          ),
        ]);
  }
}
