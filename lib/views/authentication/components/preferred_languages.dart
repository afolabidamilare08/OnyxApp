import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/authentication/components/signup_widget.dart';


import '../../../core/constants/textstyle.dart';
import '../../../models/exceptions.dart';
import '../../../models/failure.dart';
import '../../../utils/color.dart';
import '../../../widgets/flushbar.dart';
import '../../../widgets/loaderpage.dart';
import '../../../widgets/next_circular_button.dart';
import '../view model/signup_viewmodel.dart';

final signupViewModel =
    ChangeNotifierProvider.autoDispose((ref) => SignupViewModel());

class PreferredLanguages extends ConsumerStatefulWidget {
  PreferredLanguages({
    Key? key,
    this.onBack,
    this.onNext,
  }) : super(key: key);
  final Function()? onBack;
  final Function()? onNext;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreferredLanguagesState();
}

class _PreferredLanguagesState extends ConsumerState<PreferredLanguages> {
  @override
  Widget build(
    BuildContext context,
  ) {
    var model = ref.watch(signupViewModel);

    return LoaderPage(
      loading: model.isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SignupWidget(
          onBack: widget.onBack,
          text: 'Preferred language',
          subText: 'What language are you most comfortable with?',
          children: Column(children: [
            Container(
                padding:const EdgeInsets.only(left: 8),
                width: double.infinity,
                height: 61,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kBorderColor)),
                child: Row(children: [
                  Container(
                      padding:const EdgeInsets.only(left: 5),
                      height: 45,
                      width: 89,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kPrimaryColor),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField2<String>(
                            dropdownFullScreen: false,
                            offset: const Offset(-10, -20),
                            alignment: Alignment.centerLeft,
                            value: model.language2,
                            selectedItemBuilder: (context) => [
                              Text(model.language2!,
                                  style: body2L.copyWith(color: kSecondaryColor)),
                              Text(model.language2!,
                                  style: body2L.copyWith(color: kSecondaryColor)),
                              Text(model.language2!,
                                  style: body2L.copyWith(color: kSecondaryColor)),
                            ],
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                            // isExpanded: true,
    
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: kSecondaryColor,
                            ),
                            // iconSize: 30,
                            // buttonHeight: 60,
                            buttonPadding:
                                const EdgeInsets.only(left: 0, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryColor,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.shade300,
                              //     // spreadRadius: 5,
    
                              //     blurRadius: 10,
                              //   ),
                              // ],
                            ),
                            dropdownWidth: 150,
                            // items: model.buildGenderDropdown(),
                            items: model.languages
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Row(
                                        children: [
                                          Text(item,
                                              style: body2L.copyWith(
                                                  color: kSecondaryColor)),
                                        ],
                                      ),
                                    ))
                                .toList(),
    
                            onChanged: (String? e) => model.selectLanguage(e!),
                          ),
                        ),
                      )),
                ])),
            SizedBox(
              height: (MediaQuery.of(context).size.height * 25) / 100,
            ),
            GestureDetector(
              onTap: () async {
                try {
                   model.isLoading = true;
                    
                 await model.language(model.language2!);
                   model.isLoading = false;
                  widget.onNext!();
                }on Failure catch (e) {
                  OnyxFlushBar.showError(title: e.title, message: e.message);
                }
                model.isLoading = false;
              },
              child: const NextCircularButton(),
            )
          ]),
        ),
      ),
    );
  }
}
