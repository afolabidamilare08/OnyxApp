import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/authentication/models/signup_model.dart';

import '../../../models/exceptions.dart';
import '../../../models/failure.dart';

import '../../../utils/validators.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/flushbar.dart';
import '../../../widgets/loaderpage.dart';
import '../../../widgets/next_circular_button.dart';
import '../view model/signup_viewmodel.dart';
import 'signup_widget.dart';

final signupViewModel = ChangeNotifierProvider((ref) => SignupViewModel());

class PhoneNumber extends ConsumerWidget {
   PhoneNumber({Key? key, this.onBack, this.onNext}) : super(key: key);
  final Function()? onBack;
  final Function()? onNext;
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(signupViewModel);
    
    //List name = AuthRepositoryImpl().fullname.toString().split(' ');
    return LoaderPage(
      loading: model.isLoading,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SignupWidget(
          onBack: onBack,
          text: 'Hi there,\n Whats your Phone number?',
          subText: "You'll use this number to Log into your account",
          children: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: model.formKey,
            child: Column(
              children: [
                // PhoneTextField(
                //   controller: phoneController,
                // ),
                AppTextField(
                  maxLines: 1,
                  height: 61,
                  labelText: 'Phone Number',
                  keyboardType: TextInputType.number,
                  controller: phoneController,
                  validator: TextFieldValidators.phonenumber,
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height * 10) / 100,
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      model.isLoading = true;
                    var response =
                          await model.phoneumber(phoneController.text);
                      // if (response.containsKey('error')) {
                      //   model.isLoading = false;
                      // } else {
                        model.isLoading = false;
                        onNext!();
                      //}
                    } on Failure catch (e) {
                  OnyxFlushBar.showError(title: e.title, message: e.message);
                }
                model.isLoading = false;
                  },
                  child: const NextCircularButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
