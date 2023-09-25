import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/custom_icons.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/utils/validators.dart';
import 'package:onyxswap/views/forget%20password/component/forget_password_widget.dart';
import 'package:onyxswap/views/forget%20password/component/verify_otp.dart';
import 'package:onyxswap/views/forget%20password/viewmodel/forget_viewmodel.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/app_text_field.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

final _forgetPassword = ChangeNotifierProvider.autoDispose(
  (ref) => ForgetPasswordViewmodel(),
);

class ForgetPassword extends ConsumerWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(_forgetPassword);
    TextEditingController phonenumber = TextEditingController();
    //List<String> subtitle = ['potof***@domain.com', '080****1234'];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LoaderPage(
          loading: model.isLoading,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: kSecondaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      //width: 206,
                      child: AppText.heading1L(
                        'Did you forget your Password',
                        multitext: true,
                        color: kSecondaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText.body2L(
                      'Don’t worry, we will get it sorted out in no time',
                      color: kSecondaryColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                // AppText.body2L(
                //   'Select which contact details we should use to reset your password ',
                //   color: kSecondaryColor,
                //   multitext: true,
                // ),
                // Column(
                //   children: [
                //     ...List.generate(
                //         model.icon.length,
                //         (index) => ForgetPasswordWidget(
                //               icon: model.icon[index],
                //               title: model.title[index],
                //               //subtitle: subtitle[index],
                //               onTap: () =>model.onSendSMSTap() ,
                //             )),
                //   ],
                // ),
                Form(
                  key: model.phoneformkey,
                  child: AppTextField(
                    maxLines: 1,
                    height: 61,
                    labelText: 'Phone Number',
                    hText: 'Enter your phone number',
                    headingText: 'Phone Number',
                    controller: phonenumber,
                    keyboardType: TextInputType.number,
                    validator: TextFieldValidators.phonenumber,
                  ),
                ),
                Spacer(),
                AppButton(
                  title: 'Continue',
                  onTap: () => model.onSendSMSTap(phonenumber.text),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
