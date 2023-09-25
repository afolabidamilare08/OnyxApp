import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/data/local/local_cache/local_cache_impl.dart';
import 'package:onyxswap/models/chatMessgaeModel.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/launch_link.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../core/constants/textstyle.dart';
import '../utils/locator.dart';
import '../utils/validators.dart';
import 'keyboard_key.dart';

class PinBottomSheet extends StatefulWidget {
  const PinBottomSheet({
    Key? key,
    required this.amount,
    required this.controller,
    this.onCompleted,
    this.isloading,
  }) : super(key: key);
  final String amount;
  final TextEditingController controller;
  // final Function() onTap;
  final void Function(String)? onCompleted;
  final bool? isloading;

  @override
  State<PinBottomSheet> createState() => _PinBottomSheetState();
}

class _PinBottomSheetState extends State<PinBottomSheet> {
  @override
  // void dispose() {
  //   widget.controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    List keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      const Icon(
        Icons.backspace,
        color: kSecondaryColor,
      )
    ];
    return Stack(
      children: [
        Container(
          height: (MediaQuery.of(context).size.height * 2) / 3,
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        AppText.body1L(
                          'Input PIN to Pay',
                          color: kSecondaryColor,
                        ),
                        IconButton(
                            onPressed: () {
                              widget.controller.clear();
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: kSecondaryColor,
                            ))
                      ],
                    ),
                    // AppText.body1L(
                    //   '₦${widget.amount}.00',
                    //   color: kSecondaryColor,
                    //   centered: true,
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        LocalCache localCache = locator<LocalCache>();
                        String? userid = localCache.getToken();
                        LaunchLink.launchURL(
                           Uri.parse( 'http://54.197.98.127:8000/forgotpin?userid=$userid'));
                      },
                      child: AppText.body4P(
                        'Forgot Pin?',
                        color: Colors.blueAccent[400],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    widget.isloading == true
                        ? CircularProgressIndicator(
                            color: kPrimaryColor,
                          )
                        : PinCodeTextField(
                            controller: widget.controller,
                            autoDisposeControllers: false,
                            //focusNode: FocusScope.of(context),
                            validator: TextFieldValidators.pin,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            blinkWhenObscuring: false,
                            blinkDuration: const Duration(seconds: 2),
                            mainAxisAlignment: MainAxisAlignment.center,
                            //textStyle: pinStyle.copyWith(color: kSecondaryColor),
                            textStyle: body7L.copyWith(color: kSecondaryColor),
                            appContext: context,
                            length: 4,
                            onChanged: (value) {
                              //value = pin;
                            },
                            onCompleted: widget.onCompleted,
                            //widget.controller.clear();

                            pinTheme: PinTheme(
                                selectedColor:
                                    kSecondaryColor.withOpacity(0.62),
                                activeColor: kSecondaryColor,
                                inactiveColor: kSecondaryColor,
                                shape: PinCodeFieldShape.box,
                                fieldWidth: 50,
                                //fieldHeight: 50,
                                fieldOuterPadding: EdgeInsets.only(right: 10)),
                          ),
                  ],
                ),

                SizedBox(
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: GridView.count(
                        childAspectRatio:
                            MediaQuery.of(context).size.height < 700
                                ? 3.0
                                : 2.0,
                        crossAxisCount: 3,
                        children: [
                          ...List.generate(
                              12,
                              (index) => KeyboardKey(
                                    label: keys[index],
                                    value: keys[index],
                                    onTap: (value) {
                                      if (!mounted) {
                                        //widget.controller.dispose();
                                        return;
                                      }
                                      //widget.controller.clear();
                                      else {
                                        // setState(() {});
                                        if (index == 11 &&
                                            widget.controller.text.length <=
                                                4) {
                                          widget.controller.text =
                                              widget.controller.text.substring(
                                                  0,
                                                  widget.controller.text
                                                          .length -
                                                      1);
                                        } else if (widget
                                                .controller.text.length <=
                                            4) {
                                          value = keys[index];
                                          widget.controller.text =
                                              widget.controller.text + value;
                                          print(value);
                                        }

                                        //widget.controller.dispose();
                                        setState(() {});
                                      }
                                      //  else {
                                      //   widget.controller.clear();
                                      //   return;
                                      // }
                                    },
                                  )),
                        ]))
                //AppButton(title: 'PAY',showBorder: true,width: 80,onTap:onTap ,)
              ],
            ),
          ),
        ),
        widget.isloading ?? false
            ? Container(
                height: (MediaQuery.of(context).size.height * 2) / 3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.black.withOpacity(0.35),
                  //color: Colors.red
                ),
                child: SizedBox(
                    height: 20,
                    width: 20,
                    child: Center(
                        child: Lottie.asset("assets/lotties/loader.json",
                            height: 40, width: 40))),
              )
            : SizedBox()
      ],
    );
  }
}
