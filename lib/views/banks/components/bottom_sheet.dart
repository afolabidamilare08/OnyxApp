// ignore_for_file: dead_code

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/core/constants/textstyle.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/app_text_field.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

import '../view model/add_bank_viewmodel.dart';

final _addBankViewModel =
    ChangeNotifierProvider.autoDispose((ref) => AddBankViewModel());

class BottomSheetWidget extends ConsumerStatefulWidget {
  const BottomSheetWidget({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomSheetWidgetState();
}

TextEditingController controller = TextEditingController();

class _BottomSheetWidgetState extends ConsumerState<BottomSheetWidget> {
  @override
  void initState() {
    Future.delayed(
        const Duration(seconds: 2), ref.read(_addBankViewModel).addBank2);

    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    var model = ref.watch(_addBankViewModel);
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          color: kBlackColor),
      child: LoaderPage(
        loading: model.isLoading,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Form(
            key: model.formKey,
            child: ListView(
              children: [
                AppText.heading3L(
                  'Let’s add your bank account',
                  centered: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                AppText.body9L(
                  'Before you withdraw you neeed to link a bank account in your name',
                  centered: true,
                  color: kSecondaryColor,
                ),
                const SizedBox(
                  height: 47,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 15, 32, 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: kBorderColor),
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.body3L(
                        'Bank name',
                        color: kSecondaryColor,
                      ),
                      DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: false,
                          child: DropdownButton2<String>(
                              dropdownWidth: MediaQuery.of(context).size.width,
                              dropdownFullScreen: false,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor,
                              ),
                              offset: const Offset(-10, -20),
                              value: model.mybank,
                              iconSize: 30,
                              style: body3L,
                              hint: AppText.body3L(model.text),
                              onChanged: (value) {
                                setState(() {
                                  model.mybank = value;
                                  model.addBank2();
                                });
                              },
                              items: model.listOfBank
                                  ?.map((item) => model.buildMenuItem(
                                      item['name'], item['code']))
                                  .toList()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                AppTextField(
                  maxLines: 1,
                  height: 61,
                  hText: 'Account Number',
                  headingText: 'Account Number',
                  keyboardType: TextInputType.phone,
                  controller: controller,
                  validator: (value) {
                    if (value!.length < 10 || value.length > 10) {
                      return 'Account number cannot be greater or less than 10';
                    } else if (value.isEmpty) {
                      return 'Enter Account Number';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 62,
                ),
                model.checkDetails
                    ? Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: kPrimaryColor.withOpacity(0.23)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText.body3L(
                                    'Account Name',
                                    color: kSecondaryColor,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  AppText.body3L(
                                    model.bankDetails['account_name'],
                                    color: kSecondaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 37,
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: AppButton(
                          isDisabled: false,
                          title: 'Check Details',
                          height: 54,
                          onTap: () async {
                            if (model.formKey.currentState!.validate()) {
                              await model.validateAccountNumber(
                                  code: model.mybank!.split(' ')[0],
                                  accountNumber: controller.text);
                            }
                          },
                        ),
                      ),
                model.checkDetails
                    ? Column(
                        children: [
                          Row(
                            children: [
                              AppText.body2L(
                                'Save bank account details',
                                color: kSecondaryColor,
                              ),
                              const Spacer(),
                              Checkbox(
                                value: model.checkbox,
                                onChanged: (value) => model.togglecheck(),
                                activeColor: kSecondaryColor,
                                checkColor: kBorderColor,
                                hoverColor: kBorderColor,
                                //overlayColor: kBorderColor,
                              ),
                              // const Icon(
                              //   Icons.check_box_outline_blank_outlined,
                              //   color: kSecondaryColor,
                              // ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
                model.checkDetails
                    ? Column(
                        children: [
                          AppButton(
                              title: 'Continue',
                              onTap: () async {
                                await model.addAccountNumber(
                                    accountnumber: controller.text,
                                    code: model.mybank!.split(' ')[0],
                                    bankname: model
                                        .getBankName(model.mybank!.split(' ')),
                                    accountName:
                                        model.bankDetails['account_name']);
                                        
                               // await model.getAddedbank();

                               // Navigator.pop(context);
                                //model.addBank(addBankModel);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => AddBank()));
                                // print(addBankModel);
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );

    // });
  }
}
