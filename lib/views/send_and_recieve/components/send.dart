import 'package:barcode_widget/barcode_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/app_text_field.dart';

class Send extends StatefulWidget {
  const Send({
    Key? key,
    required this.recipient,
    required this.amount,
    required this.network,
    required this.balance,
    required this.ontap,
    required this.formkey,
    required this.haserror,
    required this.charges,
  }) : super(key: key);
  final TextEditingController recipient;

  final TextEditingController amount;
  final Widget network;
  final Function() ontap;
  final bool haserror;
  final String? charges;
  final String? balance;
  final GlobalKey<FormState> formkey;
  @override
  State<Send> createState() => _SendState();
}

String text = 'BTC';
List<String> items = ['BTC', 'USDT', 'BUSD'];
TextEditingController controller = TextEditingController();

class _SendState extends State<Send> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: widget.formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height < 700 ? 40 : 80,
            ),
            Container(
              height: 51,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: kBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: widget.network,
            ),
            widget.haserror
                ? AppText.body3L(
                    'Asset cannot be empty',
                    color: Colors.red,
                  )
                : SizedBox(),
            const SizedBox(
              height: 32,
            ),
            AppTextField(
              maxLines: 1,
              height: 44,
              labelText: "Input recipient Address or recipent username",
              controller: widget.recipient,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'recipient Address Cannot be empty';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 29,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  title: "Scan QR",
                  prefixIcon: Icons.qr_code,
                  width: MediaQuery.of(context).size.width / 2.5,
                  onTap: () async {
                    String barcodeScanRes =
                        await FlutterBarcodeScanner.scanBarcode(
                            '0xffffff', 'Cancel', true, ScanMode.DEFAULT);
                    widget.recipient.text = barcodeScanRes;
                  },
                ),
                AppButton(
                    title: "Paste Address",
                    prefixIcon: Icons.content_copy,
                    width: MediaQuery.of(context).size.width / 2.5,
                    onTap: () async {
                      final value = await FlutterClipboard.paste();
                      widget.recipient.text = value;
                    }),
              ],
            ),
            // const SizedBox(
            //   height: 46,
            // ),
            // AppTextField(
            //   maxLines: 1,
            //   height: 44,
            //   headingText: "Address",
            //   labelText: "Input Address",
            //   controller: widget.sender,
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return "sender's Address Cannot be empty";
            //     } else {
            //       return null;
            //     }
            //   },
            // ),
            const SizedBox(
              height: 32,
            ),
            AppTextField(
              maxLines: 1,
              height: 44,
              headingText: "Amount",
              labelText: "Input Amount",
              controller: widget.amount,
              otherText:
                  widget.balance == null ? '' : 'Balance: ${widget.balance}',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Amount Cannot be empty';
                }  else if (double.tryParse(value)! <= 0) {
                  return 'Amount must be greater than zero';
                }
                else {
                  return null;
                }
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 10,
            ),
            widget.charges != null
                ? AppText.body3L(
                    'Fee: ${widget.charges}',
                    color: kSecondaryColor,
                  )
                : SizedBox(),
            const SizedBox(
              height: 52,
            ),
            AppButton(
              title: "Send",
              onTap: widget.ontap,
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
