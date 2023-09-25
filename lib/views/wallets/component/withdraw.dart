import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onyxswap/views/buy_and_sell/components/loader.dart';

import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/app_text_field.dart';
import 'package:onyxswap/widgets/background_widget.dart';
import 'package:onyxswap/widgets/debounce.dart';

import '../../../core/constants/custom_icons.dart';
import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../viewmodel/wallet_viewmodel.dart';

final _walletViewmodel =
    ChangeNotifierProvider.autoDispose((ref) => WalletViewModels());

class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  TextEditingController amount = TextEditingController();
  TextEditingController twoFA = TextEditingController();
  TextEditingController pin = TextEditingController();
  Debouncer debouncer = Debouncer(milliseconds: 615);
  String? charge;
  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero, () => ref.read(_walletViewmodel).fetchbank(context));
  }

  @override
  Widget build(BuildContext context) {
    var model = ref.watch(_walletViewmodel);
    return BackgroundWidget(
        flexibleSpace: 150,
        buyAndSell: false,
        sendAndRecieve: false,
        flexibleChild: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                NyxIcons.arrow_back,
                color: kSecondaryColor,
              ),
            ),
            AppText.heading1L(
              'Withdraw',
              color: kSecondaryColor,
            ),
            const SizedBox(
              width: 40,
            )
          ],
        ),
        children: [
          Stack(
            children: [
              model.isLoading
                  ? const PinLoader()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                      child: Form(
                        key: model.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height < 700
                                  ? 40
                                  : 80,
                            ),
                            Container(
                              height: 51,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: kBorderColor,
                                  ),
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: model.buildDropdown(context),
                            ),
                            model.haserror
                                ? AppText.body3L(
                                    'Bank cannot be empty',
                                    color: Colors.red,
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 32,
                            ),
                            AppTextField(
                              maxLines: 1,
                              height: 61,
                              labelText: 'Amount',
                              onValueChanged: (value) {
                                if (value.isNotEmpty) {
                                  debouncer.run(() {
                                    model.getCharge(value);
                                  });
                                } else {
                                  model.getCharge('0');
                                }
                              },
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Amount cannot be empty';
                                } else if (int.tryParse(v)! < 100) {
                                  return 'Amount cannot be less than 100 naira';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              otherText: 'N${model.getBalance()}',
                              controller: amount,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            model.chargeLoading
                                ? const SizedBox(
                                    height: 14,
                                    width: 14,
                                    child: CircularProgressIndicator(
                                      color: kSecondaryColor,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : AppText.body4L(
                                    'Charge: ${model.withdrawcharges ?? '0'}',
                                    color: kSecondaryColor,
                                    centered: false,
                                  ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: AppButton(
                                  title: 'Withdraw',
                                  height: 51,
                                  onTap: () {
                                    if (model.formKey.currentState!
                                        .validate()) {
                                      model.twoFA(
                                          amount: amount.text,
                                          pin: pin,
                                          twoFA: twoFA);
                                      // showModalBottomSheet(
                                      //     context: context,
                                      //     builder: (context) => PinBottomSheet(
                                      //           amount: amount.text,
                                      //           controller: pin,
                                      //           isloading: model.isLoading,
                                      //           onCompleted: (value) {
                                      //             model.checkPin(
                                      //                 amount: amount.text,
                                      //                 pin: pin,
                                      //                 context: context);
                                      //           },
                                      //         ));
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          )
        ]);
  }
}
