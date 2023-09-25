import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/utils/validators.dart';

import 'package:onyxswap/views/Security/view_model/setup_pin_viewmodel.dart';

import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/app_text_field.dart';
import 'package:onyxswap/widgets/loaderpage.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';

final pinsetupViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => SetupPinViewModel());

class PinSetup extends ConsumerWidget {
  PinSetup(
      {Key? key,
      required this.heading,
      required this.title,
      required this.subtitle})
      : super(key: key);
  final String heading;
  final String title;
  final String subtitle;
   TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(pinsetupViewmodel);

    return Scaffold(
      body: LoaderPage(
        loading: model.isLoading,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Form(
            key: model.formKey,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: kSecondaryColor,
                        )),
                    AppText.heading1L(
                      heading,
                      color: kSecondaryColor,
                    ),
                    SizedBox(
                      width: 40,
                    )
                  ],
                ),
                const SizedBox(
                  height: 42,
                ),
                AppText.heading7L(
                  "Let's help you set up your transaction pin",
                  multitext: true,
                  color: kSecondaryColor,
                  centered: true,
                ),
                const SizedBox(
                  height: 22,
                ),
                Column(
                  children: [
                    AppTextField(
                      maxLines: 1,
                      height: 61,
                      headingText: title,
                      isPassword: true,
                      validator: (v) => TextFieldValidators.pin(v),
                      keyboardType: TextInputType.number,
                      controller: pinController,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    AppTextField(
                      maxLines: 1,
                      height: 61,
                      headingText: subtitle,
                      controller: model.controller,
                      isPassword: true,
                      validator: (v) {
                        if (pinController.text != v) {
                          return "Pin don't match";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                ),
                AppButton(
                  title: 'Confirm',
                  onTap: () {
                    if (model.formKey.currentState!.validate()) {
                      model.createPin(pinController.text);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
