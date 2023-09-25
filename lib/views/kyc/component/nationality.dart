import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/launch_link.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/kyc/viewmodel/nin_viewmodel.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/app_text_field.dart';
import 'package:onyxswap/widgets/drop_down.dart';
import 'package:onyxswap/widgets/loaderpage.dart';

import '../../../widgets/flushbar.dart';

final _ninViemodel = ChangeNotifierProvider.autoDispose(
  (ref) => NinViewModel(),
);

// ignore: must_be_immutable
class Nationality extends ConsumerStatefulWidget {
  Nationality({
    Key? key,
    required this.type,
    required this.hint,
  }) : super(key: key);
  final String type;
  final String hint;

  ConsumerState<ConsumerStatefulWidget> createState() => _NationalityState();
}

TextEditingController controller = TextEditingController();

class _NationalityState extends ConsumerState<Nationality> {
  @override
  Widget build(
    BuildContext context,
  ) {
    var model = ref.watch(_ninViemodel);
    return Scaffold(
      body: LoaderPage(
        loading: model.isLoading,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          CupertinoIcons.arrow_left,
                          color: kSecondaryColor,
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  AppText.heading3L(
                    "What’s your Nationality?",
                    centered: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppText.body2L(
                    'Your nationality, or where you’re from, must match whats in your ID document.',
                    centered: true,
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 32, 0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: kBorderColor),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText.body3L(
                          'Nationalty',
                          color: kSecondaryColor,
                        ),
                        DropdownButtonHideUnderline(
                          child: DropDown(
                            items: ['Nigeria', 'Ghana', 'South Africa'],
                            text: "Nigeria",
                            color: kSecondaryColor,
                            dropDownColor: kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 15, 32, 5),
                    //alignment: Alignment.centerLeft,
                    width: double.infinity,
                    height: 61,
                    decoration: BoxDecoration(
                        border: Border.all(color: kBorderColor),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.body3L(
                          'Identity Type',
                          color: kSecondaryColor,
                        ),
                        AppText.body4L(
                          widget.type,
                          color: kSecondaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Form(
                    key: model.formKey,
                    child: AppTextField(
                      maxLines: 1,
                      height: 61,
                      hText: widget.hint,
                      headingText: widget.hint,
                      controller: controller,
                      validator:widget.type=='NIN'?  (value) {
                        if (value!.isEmpty) {
                          return '${widget.type} Number cannot be empty';
                        } else if (value.length < 16 || value.length > 16) {
                          return '${widget.type} Number cannot be less or greater than 11';
                        } else {
                          return null;
                        }
                      }
                      :(value) {
                        if (value!.isEmpty) {
                          return '${widget.type} Number cannot be empty';
                        } else if (value.length < 11 || value.length > 11) {
                          return '${widget.type} Number cannot be less or greater than 11';
                        } else {
                          return null;
                        }
                      },
                      keyboardType:widget.type=='NIN'?TextInputType.visiblePassword: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // model.validate ? model.buildContainer() : const SizedBox(),

                  widget.type == 'NIN'
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kPrimaryColor),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.body3L(
                                  'To Get your Virtual NIN please visit'),
                              RichText(
                                text: TextSpan(
                                  text: 'https://nimc.gov.ng/nin-tokenization/',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => LaunchLink.launchURL(Uri.parse(
                                        'https://nimc.gov.ng/nin-tokenization')),
                                  style: GoogleFonts.lato(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                  children: [
                                    TextSpan(
                                      text: ' follow the steps',
                                      style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextSpan(
                                      text: ' Use ',
                                      style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextSpan(
                                      text: ' 1138183',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          FlutterClipboard.copy('1138183');
                                          OnyxFlushBar.showSuccess(
                                              context: context,
                                              message: 'Copied');
                                        },
                                      style: GoogleFonts.lato(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextSpan(
                                      text: ' as your enter price code',
                                      style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  const SizedBox(
                    height: 32,
                  ),
                  AppButton(
                      title: "Verify",
                      onTap: () async {
                        if (model.formKey.currentState!.validate()) {
                          if (widget.type == 'NIN') {
                            // model.validate?model.addBVN(controller.text, context, 'NIN'): model.ninValidation(controller.text, context);
                            await model.bvnValidation(
                                bvn: controller.text,
                                context: context,
                                type: 'NIN');
                          } else if (widget.type == 'BVN') {
                            await model.bvnValidation(
                                bvn: controller.text,
                                context: context,
                                type: 'BVN');
                          }
                        }
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
