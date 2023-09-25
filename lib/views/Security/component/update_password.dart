import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/Security/component/password_widget.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/app_text_field.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../view_model/setup_pin_viewmodel.dart';

final pinsetupViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => SetupPinViewModel());

class UpdatePassword extends ConsumerWidget {
  UpdatePassword({Key? key}) : super(key: key);
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> passwordCheck = [
      'At least 8 characters',
      'Special character [e.g @ ?-Z]',
      'Uppercase letter [A-Z]',
      'Lowercase letter [A-Z]',
      'Number [0-9]'
    ];
    var model = ref.watch(pinsetupViewmodel);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: LoaderPage(
            loading: model.isLoading,
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: kSecondaryColor,
                            )),
                        AppText.heading1L(
                          'Change Password',
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
                      'Enter your old Password and your Preferred new password',
                      multitext: true,
                      color: kSecondaryColor,
                      centered: true,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 22,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: Form(
                    key: model.formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          maxLines: 1,
                          height: 61,
                          headingText: 'Old Password',
                          isPassword: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password field cannot be empty';
                            } else if (value.length < 8) {
                              return 'must be more than 8 characters';
                            } else {
                              return null;
                            }
                          },
                          obscure: true,
                          controller: oldPassword,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        AppTextField(
                          maxLines: 1,
                          height: 61,
                          headingText: 'New Password',
                          isPassword: true,
                          obscure: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password field cannot be empty';
                            } else if (value.length < 8) {
                              return 'must be more than 8 characters';
                            } else {
                              return null;
                            }
                          },
                          controller: newPassword,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                          child: GridView.count(
                            crossAxisCount: 2,
                            children: [
                              ...List.generate(
                                  passwordCheck.length,
                                  (index) => PasswordWidget(
                                      text: passwordCheck[index]))
                            ],
                            childAspectRatio: 14,
                            mainAxisSpacing: 8,
                            //crossAxisSpacing: 8,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height < 700
                      ? 0
                      : MediaQuery.of(context).size.height / 8,
                ),
                AppButton(
                  title: 'Next',
                  onTap: () {
                    if (model.formKey.currentState!.validate()) {
                      model.resetPassword(newPassword.text, context);
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
