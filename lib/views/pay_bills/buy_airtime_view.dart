import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/utils/validators.dart';
import 'package:onyxswap/views/pay_bills/components/airtime_widget.dart';
import 'package:onyxswap/views/pay_bills/components/contact_screen.dart';

import 'package:onyxswap/views/pay_bills/components/text_field.dart';
import 'package:onyxswap/views/pay_bills/viewmodels/buyAirtime_viewmodel.dart';
import 'package:onyxswap/widgets/app_button.dart';

import 'package:onyxswap/widgets/loaderpage.dart';
import '../../utils/color.dart';
import '../../utils/text.dart';

final _buyAirtimeViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => BuyAirtimeViewmodel());

// ignore: must_be_immutable
class BuyAirtime extends ConsumerWidget {
  BuyAirtime({Key? key}) : super(key: key);
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(_buyAirtimeViewmodel);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LoaderPage(
          loading: model.isLoading,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 65, top: 0),
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
                    AppText.heading4N(
                    model.airtimeText=='Data'?'Buy Data':  'Buy Airtime',
                      color: kSecondaryColor,
                      centered: true,
                      //textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                  ],
                ),
                AirtimeWidget(
                    children: SizedBox(
                  width: MediaQuery.of(context).size.width - 115,
                  child: DropdownButtonHideUnderline(
                      child: model.buildDropDown(
                    context: context,
                    hint: '',
                    items: model.airtime
                        .map((item) =>
                            model.buildMenuItem(item: item, value: item,))
                        .toList(),
                    mainvalue: model.airtimeText,
                    function: model.selectBiller,
                    onChanged: (e) {
                      model.selectBiller(e!);

                      if (model.airtimeText == 'Data' && model.biller != null) {
                        model.getDataPackages();
                      }
                    },
                  )),
                )),
                // GestureDetector(
                //   onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactScreen())),
                //child:
                AirtimeWidget(
                  onTap: () async {
                    model.result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContactScreen()));
                    //print(result);
                    phoneController.text = model.result;
                  },
                  children: SizedBox(
                    width: MediaQuery.of(context).size.width - 115,
                    child: Row(
                      children: [
                        AppText.body1L('My Contact List'),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward,
                          color: kPrimaryColor,
                        )
                      ],
                    ),
                  ),
                ),
                // ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 30, bottom: 40, left: 14, right: 14),
                        child: Form(
                          key: model.formKey,
                          child: ListView(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.heading1L(
                               model.airtimeText == 'Data'?'Buy Data': 'Buy Airtime',
                                color: const Color(0xff3a393a),
                              ),
                              const SizedBox(
                                height: 42,
                              ),
                              TextFieldWidget(
                                hintText: 'Enter Phone Number',
                                validator: TextFieldValidators.phonenumber,
                                // initialText: 'result',
                                color: kPrimaryColor,
                                textColor: kPrimaryColor,
                                controller: phoneController,
                                keyboardtype: TextInputType.number,
                                // onchanged: (value) {
                                //   setState(() {
                                //     model.validatePhone(phoneController.text);
                                //   });
                                // },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              model.buildDropDown(
                                context: context,
                                mainvalue: model.biller,
                                items: model.selectbiller
                                    .map((e) =>
                                        model.buildMenuItem(item: e, value: e))
                                    .toList(),
                                hint: model.selectbillerText,
                                function: model.selectNetwork,
                                onChanged: (e) {
                                  model.networkOnchanged(e);
                                },
                              ),
                              model.isBillerError
                                  ? AppText.body4L(
                                      'Please Select a Data plan',
                                      color: Colors.red,
                                    )
                                  : const SizedBox(),
                              model.airtimeText == 'Data'
                                  ? model.buildDropDown(
                                      context: context,
                                      mainvalue: model.data,
                                      items: model.dataPakages
                                          ?.map((e) => model.buildMenuItem2(
                                              item: e['name'],
                                              value: e['variation_code'],
                                              amount: e['variation_amount']))
                                          .toList(),
                                      hint: model.dataPlan,
                                      function: model.selectdataplan,
                                      onChanged: (e) =>
                                          model.selectdataplan(e!),
                                    )
                                  : const SizedBox(),
                              model.isDataError
                                  ? AppText.body4L(
                                      'Please Select Network',
                                      color: Colors.red,
                                    )
                                  : const SizedBox(),
                              model.airtimeText == 'Data'
                                  ? SizedBox()
                                  : TextFieldWidget(
                                      color: kPrimaryColor,
                                      textColor: kPrimaryColor,
                                      hintText: 'Amount',
                                      controller: amountController,
                                      keyboardtype: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Amount cannot be empty';
                                        } else if (int.parse(value) < 100) {
                                          return 'Amount must be greater than 100 naira';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                              const SizedBox(
                                height: 65,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 34.0),
                                child: AppButton(
                                    title: 'Continue',
                                    onTap: () async {
                                      await model.onContinueTap(
                                          context: context,
                                          phone: phoneController.text,
                                          amount: amountController.text,
                                          pin: pinController);
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
