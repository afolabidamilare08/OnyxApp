import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/pay_bills/viewmodels/cable_viwmmodel.dart';
import 'package:onyxswap/views/pay_bills/components/cable_widget.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/app_text_field.dart';

import 'package:onyxswap/widgets/loaderpage.dart';

import '../../../core/constants/textstyle.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';

final _cablViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => CableViewmodel());

class Cable extends ConsumerWidget {
   Cable({Key? key}) : super(key: key);
 TextEditingController cardnumberController = TextEditingController();
    TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(_cablViewmodel);
   
    return Scaffold(
      body: LoaderPage(
        loading: model.isLoading,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 80),
          child: Form(
            key: model.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: kSecondaryColor,
                        )),
                    AppText.heading1L(
                      'Cable',
                      color: kSecondaryColor,
                    ),
                    const SizedBox(
                      width: 40,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.button2L(
                      'Select Tv networks',
                      color: kSecondaryColor,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...List.generate(
                              model.type.length,
                              (index) => GestureDetector(
                                  onTap: () {
                                    model.onTap(index);
                                    model.onCableTap(index);
                                  },
                                  child: CableWidget(
                                    type: model.type[index],
                                    selected:
                                        model.type[index] == model.selectedType,
                                  )))
                        ],
                      ),
                    ),
                    model.isBillerError
                        ? AppText.body4L(
                            'Please Select Biller',
                            color: Colors.red,
                          )
                        : const SizedBox(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.button2L(
                      'Select subscription plan',
                      color: kSecondaryColor,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      height: 51,
                      decoration: BoxDecoration(
                          border: Border.all(color: kSecondaryColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: false,
                          child: DropdownButton2<String>(
                              dropdownWidth: MediaQuery.of(context).size.width,
                              dropdownFullScreen: false,
                              isExpanded: true,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor,
                              ),
                              offset: const Offset(-10, -20),
                              value: model.text,
                              iconSize: 30,
                              style: body3L.copyWith(color: kSecondaryColor),
                              hint: AppText.body3L(model.hint),
                              onChanged: (value) => model.onChanged(value!),
                              items: model.subscription
                                  ?.map((item) => model.buildMenuItem(
                                      item['name'], item['variation_code'],item['variation_amount']))
                                  .toList()),
                        ),
                      ),
                    ),
                    model.isSubsriptionError
                        ? AppText.body4L(
                            'Please Select a Subsription Plan',
                            color: Colors.red,
                          )
                        : const SizedBox(),
                  ],
                ),
                AppTextField(
                  maxLines: 1,
                  height: 61,
                  headingText: 'Card Number',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.length < 10 || value.length > 10) {
                      return 'Cable number cannot be greater or less than 10';
                    } else if (value.isEmpty) {
                      return 'Enter Cable Number';
                    } else {
                      return null;
                    }
                  },
                  controller: cardnumberController,
                ),
                // Row(
                //   children: [
                //     //Checkbox(value: model.value, onChanged:model.toggle(model.value),activeColor: kSecondaryColor,),
                //     AppText.button2L(
                //       'Save Beneficiary for faster transaction',
                //       color: kSecondaryColor,
                //     )
                //   ],
                // ),
                AppButton(
                    title: 'Continue',
                    onTap: () async => await model.onContinueTap(
                        cardNumber: cardnumberController.text,
                        pin: pinController,
                        context: context))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
