import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/remote/auth/auth_interface.dart';
import '../../../models/exceptions.dart';

import '../../../models/failure.dart';
import '../../../utils/locator.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/flushbar.dart';
import '../../../widgets/loaderpage.dart';
import '../../../widgets/next_circular_button.dart';
import '../view model/signup_viewmodel.dart';
import 'signup_widget.dart';

final signupViewModel =
    ChangeNotifierProvider.autoDispose((ref) => SignupViewModel());

class Fullname extends ConsumerWidget {
  Fullname({Key? key, this.onBack, this.onNext}) : super(key: key);
  final Function()? onBack;
  final Function()? onNext;
 TextEditingController fullnameController = TextEditingController();
  TextEditingController   nicknameController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(signupViewModel);
    
      final AuthService authService = locator<AuthService>();
    return LoaderPage(
      loading: model.isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SignupWidget(
            onBack: onBack,
            text: 'Enter Your Full Name',
            children: Form(
              key: model.formKey,
              //autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextField(
                    validator: (v) {
                      if (v!.isEmpty) {
                        return 'First Name cannot be empty';
                      } else {
                        return null;
                      }
                    },
                    maxLines: 1,
                    height: 61,
                    labelText: 'First Name',
                    controller: fullnameController,
                    keyboardType: TextInputType.name,
                    headingText: 'First Name',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppText.body8L(
                      //   'Preferred Nick Name',
                      //   color: kSecondaryColor.withOpacity(0.42),
                      // ),
                      // const SizedBox(
                      //   height: 17,
                      // ),
                      AppTextField(
                        controller: nicknameController,
                        maxLines: 1,
                        height: 61,
                        headingText: 'Last Name',
                        hText: 'Last Name',
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'Last Name cannot be empty';
                          } else {
                            return null;
                          }
                        },
                        //keyboardType: TextInputType.,
                      )
                    ],
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height * 9.7) / 100,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (model.formKey.currentState!.validate()) {
                        try {
                          model.isLoading = true;
                          await model.fullname(
                              firstname: fullnameController.text,
                              lastname: nicknameController.text);

                          model.isLoading = false;
                          onNext!();
                        } on Failure catch (e) {
                  OnyxFlushBar.showError(title: e.title, message: e.message);
                }
   model. isLoading = false;
                      }
                    },
                    child: const NextCircularButton(),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
