import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/textstyle.dart';
import '../../../models/exceptions.dart';
import '../../../models/failure.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../../../widgets/flushbar.dart';
import '../../../widgets/loaderpage.dart';
import '../../../widgets/next_circular_button.dart';
import '../view model/signup_viewmodel.dart';
import 'signup_widget.dart';

final signupViewModel =
    ChangeNotifierProvider.autoDispose((ref) => SignupViewModel());

class CountryFlag extends ConsumerStatefulWidget {
  const CountryFlag({
    Key? key,
    this.onBack,
    this.onNext,
  }) : super(key: key);
  final Function()? onBack;
  final Function()? onNext;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountryFlagState();
}

//SignupViewModel _signupViewModel = SignupViewModel();

class _CountryFlagState extends ConsumerState<CountryFlag> {
  final showCountryPicker = const FlCountryCodePicker(
      filteredCountries: ['NG', 'ZA', 'GH'], showSearchBar: false);
  CountryCode? country2;
  String? country3;
  @override
  Widget build(BuildContext context) {
    var model = ref.watch(signupViewModel);

    return LoaderPage(
      loading: model.isLoading,
      child: SignupWidget(
        onBack: widget.onBack,
        text: 'Country of Residence',
        subText: 'What country do you currently live in?',
        children: Column(
          children: [
            Container(
              height: 61,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final code = await showCountryPicker.showPicker(
                          context: context, pickerMaxHeight: 250);

                      setState(() {
                        if (code != null) {
                          country2 = code;
                        }
                        //country2 = code??const CountryCode(name: 'Nigeria', code: '+234', dialCode: '+234');
                      });
                      //print(widget.country?.code ?? '');
                      //showCountryPicker.filteredCountries=[]
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: kSecondaryColor),
                        ),
                      ),
                      child: Row(children: [
                        country2?.flagImage ??
                            SvgPicture.asset(
                              'assets/svgs/nigerian_flag.svg',
                              height: 22,
                              width: 32,
                            ),
                        Icon(Icons.arrow_drop_down)
                      ]),
                    ),
                  ),
                  AppText.body3P(country2?.name ?? 'NIGERIA',
                      color: kSecondaryColor)
                ],
              ),
            ),
            // Container(
            //     padding: const EdgeInsets.only(left: 8),
            //     width: double.infinity,
            //     height: 61,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(8),
            //         border: Border.all(color: kBorderColor)),
            //     child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Container(
            //               padding: const EdgeInsets.only(left: 5),
            //               height: 45,
            //               width: 89,
            //               decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(8),
            //                   color: kPrimaryColor),
            //               child: Center(
            //                 child: DropdownButtonHideUnderline(
            //                   child: DropdownButtonFormField2<String>(
            //                     dropdownFullScreen: false,
            //                     offset: const Offset(-10, -20),
            //                     alignment: Alignment.centerLeft,
            //                     value: model.country2,
            //                     selectedItemBuilder: (context) => [
            //                       Text(model.country2!,
            //                           style: body2L.copyWith(
            //                               color: kSecondaryColor)),
            //                       Text(model.country2!,
            //                           style: body2L.copyWith(
            //                               color: kSecondaryColor)),
            //                       Text(model.country2!,
            //                           style: body2L.copyWith(
            //                               color: kSecondaryColor)),
            //                     ],
            //                     decoration: const InputDecoration(
            //                       isDense: true,
            //                       contentPadding: EdgeInsets.zero,
            //                       border: InputBorder.none,
            //                     ),
            //                     // isExpanded: true,

            //                     icon: const Icon(
            //                       Icons.arrow_drop_down,
            //                       color: kSecondaryColor,
            //                     ),
            //                     // iconSize: 30,
            //                     // buttonHeight: 60,
            //                     buttonPadding:
            //                         const EdgeInsets.only(left: 0, right: 10),
            //                     dropdownDecoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10),
            //                       color: kPrimaryColor,
            //                       // boxShadow: [
            //                       //   BoxShadow(
            //                       //     color: Colors.grey.shade300,
            //                       //     // spreadRadius: 5,

            //                       //     blurRadius: 10,
            //                       //   ),
            //                       // ],
            //                     ),
            //                     dropdownWidth: 150,
            //                     // items: model.buildGenderDropdown(),
            //                     items: model.countryvalue
            //                         .map((item) => DropdownMenuItem<String>(
            //                               value: item,
            //                               child: Row(
            //                                 children: [
            //                                   Text(item,
            //                                       style: body2L.copyWith(
            //                                           color: kSecondaryColor)),
            //                                 ],
            //                               ),
            //                             ))
            //                         .toList(),

            //                     onChanged: (String? e) =>
            //                         model.selectCountry(e!),
            //                   ),
            //                 ),
            //               )),
            //           AppText.heading2L(model.country2!),
            //           SizedBox(
            //             width: 20,
            //           )
            //         ])),
            SizedBox(
              height: (MediaQuery.of(context).size.height * 25) / 100,
            ),
            GestureDetector(
              onTap: () async {
                try {
                  model.isLoading = true;
                  await model.country(country2?.name ?? 'Nigeria');
                  model.isLoading = false;
                  widget.onNext!();
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
    );
  }
}
