import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/utils/validators.dart';
import 'package:onyxswap/views/pay_bills/components/text_field.dart';
import 'package:onyxswap/views/pay_bills/viewmodels/electricity_viewmodel.dart';
import 'package:onyxswap/widgets/app_button.dart';

import 'package:onyxswap/widgets/loaderpage.dart';


final _electricityViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => ElectricityViewmodel());

class Electricity extends ConsumerWidget {
  Electricity({Key? key}) : super(key: key);
TextEditingController meterController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    var model = ref.watch(_electricityViewmodel);

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LoaderPage(
            loading: model.isLoading,
            child: Padding(
              padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 80
                  // MediaQuery.of(context).size.height / 5
                  ),
              child: Form(
                key: model.formKey,
                child: ListView(children: [
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
                      AppText.heading4N(
                        'Electricity',
                        color: kSecondaryColor,
                        centered: true,
                        //textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  AppText.heading6L(
                    'Enter Details',
                    color: kSecondaryColor,
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  model.buildDropDown(
                      context: context,
                      items: model.selectbiller
                          .map((item) => model.buildMenuItem(
                              item['name'].toString(), item['value'].toString()))
                          .toList(),
                      onChanged: (e) => model.selectBiller(e!),
                      hint: model.selectbillerHintText,
                      mainvalue: model.selectbillerText),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      model.buildDropDown(
                          context: context,
                          items: model.paymentItem
                              .map((e) => model.buildMenuItem(e, e))
                              .toList(),
                          hint: model.paymentItemHintText,
                          mainvalue: model.paymentItemText,
                          onChanged: (e) => model.selectPaymentItem(e!)),
                      const SizedBox(
                        height: 15,
                      ),
                      //AppTextField(maxLines: 1, height: height)
                      TextFieldWidget(
                          hintText: "Meter number",
                          color: kSecondaryColor,
                          textColor: kSecondaryColor,
                          controller: meterController,
                          cursorcolor: kSecondaryColor,
                          keyboardtype: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Meter Number cannot be empty';
                            } else if (value.length < 7&& value.length >= 13) {
                              return 'Meter Number cannot be greater than or less than  11 digits';
                            } else {
                              return null;
                            }
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                        hintText: 'Amount',
                        color: kSecondaryColor,
                        textColor: kSecondaryColor,
                        controller: amountController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Amount cannot be empty';
                          } else if (int.parse(value) < 500) {
                            return 'Amount must be greater than 500 naira';
                          } else {
                            return null;
                          }
                        },
                        keyboardtype: TextInputType.number,
                        cursorcolor: kSecondaryColor,
                      ),
          
                      const SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                        hintText: 'Phone Number',
                        color: kSecondaryColor,
                        textColor: kSecondaryColor,
                        controller: phoneController,
                        validator: TextFieldValidators.phonenumber,
                        keyboardtype: TextInputType.number,
                        cursorcolor: kSecondaryColor,
                      ),
                      //const Spacer(),
                      const SizedBox(
                        height: 80,
                      ),
                      AppButton(
                        title: 'Continue',
                        onTap: () => model.validateMeterNumber(
                            meterNumber: meterController.text,
                            context: context,
                            amount: amountController.text,
                            pin: pinController),
                      )
                    ],
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
