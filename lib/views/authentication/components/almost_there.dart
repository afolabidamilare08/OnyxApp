import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/models/chatMessgaeModel.dart';

import '../../../core/constants/custom_icons.dart';
import '../../../data/local/local_cache/local_cache.dart';
import '../../../models/exceptions.dart';
import '../../../models/failure.dart';
import '../../../utils/color.dart';
import '../../../utils/locator.dart';
import '../../../utils/text.dart';
import '../../../utils/validators.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/flushbar.dart';
import '../../../widgets/loaderpage.dart';
import '../../../widgets/next_circular_button.dart';
import '../view model/signup_viewmodel.dart';
import 'dob.dart';

final signupViewModel =
    ChangeNotifierProvider.autoDispose((ref) => SignupViewModel());

class AlmostTherePage extends ConsumerWidget {
  AlmostTherePage({Key? key, this.onNext, this.onBack}) : super(key: key);
  final Function()? onNext;
  final Function()? onBack;
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(signupViewModel);
    LocalCache _localCache = locator<LocalCache>();
    //final TextFieldValidators textFieldValidators = TextFieldValidators();
    return LoaderPage(
      loading: model.isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: onBack,
                    child: const Icon(
                      NyxIcons.arrow_back,
                      color: kSecondaryColor,
                    )),
                AppText.heading1L(
                  "Your're Almost There!",
                  color: kSecondaryColor,
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            AppText.body3L('Please fill to continue!'),
            const SizedBox(
              height: 32,
            ),
            Form(
              key: model.formKey,
              //autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  AppTextField(
                      controller: emailController,
                      maxLines: 1,
                      height: 51,
                      labelText: 'Email',
                      validator: (v) => TextFieldValidators.email(v),
                      keyboardType: TextInputType.emailAddress),
                  // const SizedBox(
                  //   height: 20,
                  // ),

                  BuildLinearDateOfBirthField(controller: dobController),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  AppTextField(
                    // validator: TextFieldValidators.password,
                    obscure: true,
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    maxLines: 1,
                    height: 51,
                    labelText: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AppText.body6L(
                      'Password must contain a capital letter,a small letter, a number and a special character',
                      color: kSecondaryColor,
                      centered: false),
                  AppTextField(
                    controller: confirmpasswordController,
                    validator: (value) {
                      if (passwordController.text != value) {
                        return 'Password must be the same';
                      } else {
                        return null;
                      }
                    },
                    maxLines: 1,
                    height: 51,
                    labelText: 'Confirm Password',
                    keyboardType: TextInputType.visiblePassword,
                    obscure: true,
                    isPassword: true,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (model.formKey.currentState!.validate()) {
                    try {
                      model.isLoading = true;
                      var response = await model.info(
                          fbToken:
                              localCache.getFromLocalCache('firebaseToken') !=
                                      null
                                  ? localCache
                                      .getFromLocalCache('firebaseToken')
                                      .toString()
                                  : '',
                          email: emailController.text,
                          dob: dobController.text,
                          password: passwordController.text);
                      if (response.containsKey('error')) {
                        print('error');
                        model.isLoading = false;
                      } else {
                        onNext!();
                        model.isLoading = false;
                      }
                      model.isLoading = false;
                    } on Failure catch (e) {
                      OnyxFlushBar.showError(
                          title: e.title, message: e.message);
                    }
                    model.isLoading = false;
                  }
                },
                child: const NextCircularButton(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
