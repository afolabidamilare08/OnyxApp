import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/Security/component/password_widget.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/app_text_field.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

import '../../../core/routes/routing_constants.dart';
import '../../../core/services/navigation_service.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../../../widgets/transaction_successful.dart';
import '../viewmodel/forget_viewmodel.dart';

final _forgetpassword =
    ChangeNotifierProvider.autoDispose((ref) => ForgetPasswordViewmodel());

// ignore: must_be_immutable
class ResetPassword extends ConsumerWidget {
  ResetPassword({Key? key, required this.phonenumber}) : super(key: key);
  final String phonenumber;
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> passwordCheck = [
      'At least 8 characters',
      'Special character [e.g @ ?-Z]',
      'Uppercase letter [A-Z]',
      'Lowercase letter [A-Z]',
      'Number [0-9]'
    ];
    var model = ref.watch(_forgetpassword);

    NavigationService _navigationService = NavigationService.I;
    return Scaffold(
      body: SafeArea(
        child: LoaderPage(
          loading: model.isLoading,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 85),
            child: Form(
              key: model.resetformkey,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_back,
                                color: kSecondaryColor,
                              )),
                          AppText.heading1L(
                            'Reset Password',
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
                        'Enter your New Password',
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
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      children: [
                        AppTextField(
                          maxLines: 1,
                          height: 61,
                          headingText: 'New Password',
                          isPassword: true,
                          controller: password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'password field cannot be empty';
                            } else if (value.length < 8) {
                              return 'must be more than 8 characters';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        AppTextField(
                          maxLines: 1,
                          height: 61,
                          headingText: 'Confirm Password',
                          isPassword: true,
                          validator: (value) {
                            if (password.text != value) {
                              return 'Password must be the same';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Expanded(
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                  ),
                  AppButton(
                    title: 'Next',
                    onTap: () => model.resetPassword(password.text,phonenumber),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
