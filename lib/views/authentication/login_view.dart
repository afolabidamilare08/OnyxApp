import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/utils/validators.dart';
import 'package:onyxswap/views/authentication/view%20model/login_viewmodel.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/app_text_field.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

final loginViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => LoginViewModel());

class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

TextEditingController phoneController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _LoginViewState extends ConsumerState<LoginView> {
  //@override
  // void dispose() {
  //   phoneController.dispose();
  //   passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(
    BuildContext context,
  ) {
    var model = ref.watch(loginViewmodel);

    return LoaderPage(
      loading: model.isLoading,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.heading3N(
                    'Welcome Back!',
                    color: Colors.white,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  AppText.caption1N(
                    'Login to continue',
                    color: Colors.white,
                  ),

                  // AppText.body3L('Phone Number'),
                  const SizedBox(
                    height: 52,
                  ),
                  Form(
                    key: model.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Expanded(
                      child: ListView(
                        children: [
                          AppTextField(
                            maxLines: 1,
                            height: 61,
                            labelText: 'Phone Number',
                            headingText: 'Phone Number',
                            validator: TextFieldValidators.phonenumber,
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            // onValueChanged: (value) {
                            //   setState(() {
                            //     phoneNumber = value;
                            //     print(phoneNumber);
                            //   });
                            // },
                          ),
                          const SizedBox(
                            height: 45,
                          ),
                          AppTextField(
                            maxLines: 1,
                            height: 61,
                            headingText: 'Password',
                            isPassword: true,
                            iconColor: Colors.white,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            // onValueChanged: (value) {
                            //   setState(() {
                            //     password = value;
                            //   });
                            // },
                          ),
                          model.isSuspended
                              ? const SizedBox(
                                  height: 12,
                                )
                              : SizedBox(),
                          model.isSuspended
                              ? Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red,
                                  ),
                                  child: Column(children: [
                                    AppText.body3L(
                                        'Your account has been suspended you can contact support for more information through the link below'),
                                    GestureDetector(
                                        onTap: () => model.launchEmail(),
                                        child: AppText.body3L(
                                            'Gmail: hello@onyxswap.africa')),
                                    GestureDetector(
                                        onTap: () => model.launchWhatsapp(),
                                        child: AppText.body3L(
                                            'WhatsApp: 23408172247276')),
                                  ]),
                                )
                              : SizedBox(),
                          model.isSuspended
                              ? const SizedBox(
                                  height: 15,
                                )
                              : const SizedBox(
                                  height: 52,
                                ),
                          AppButton(
                              title: 'Login',
                              // onTap: () async {

                              // },
                              onTap: () => model.login(
                                  phoneNumber: phoneController.text,
                                  password: passwordController.text)),
                          const SizedBox(
                            height: 57,
                          ),
                          GestureDetector(
                            onTap: () => model.gotoForgetpassword(),
                            child: AppText.body2L(
                              'Forgot Password?',
                              color: Colors.white,
                              centered: true,
                            ),
                          ),
                          const SizedBox(
                            height: 27,
                          ),
                          GestureDetector(
                            onTap: () => model.gotoSignup(),
                            child: AppText.heading6L(
                              "Don't have an account? Sign Up",
                              color: Colors.white,
                              centered: true,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset('assets/pngs/login.png')
          ],
        ),
      ),
    );
  }
}
