// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:nyx_swap/views/pay_bills/components/text_field.dart';

// import '../../../core/constants/textstyle.dart';
// import '../../../utils/color.dart';
// import '../../../utils/text.dart';
// import '../../../widgets/app_button.dart';

// class DataWidget extends StatelessWidget {
//   const DataWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       color: kSecondaryColor,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         top: 30, bottom: 40, left: 14, right: 14),
//                     child: ListView(
//                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AppText.heading1L(
//                           'Buy Airtime',
//                           color: const Color(0xff3a393a),
//                         ),
//                         const SizedBox(
//                           height: 42,
//                         ),
//                         TextFieldWidget(
//                           hintText: 'Enter Phone Number',
//                           // initialText: 'result',
//                           color: kPrimaryColor,
//                           textColor: kPrimaryColor,
//                           controller: textEditingController,
//                           // onchanged: (value) {
//                           //   setState(() {
//                           //     textEditingController.text = result;
//                           //   });
//                           // },
//                         ),
//                         const SizedBox(
//                           height: 42,
//                         ),
//                         ButtonTheme(
//                           alignedDropdown: false,
//                           child: DropdownButton2<String>(
//                               dropdownWidth: MediaQuery.of(context).size.width,
//                               dropdownFullScreen: false,
//                               dropdownDecoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: kPrimaryColor,
//                               ),
//                               offset: const Offset(-10, -20),
//                               value: model.mybank,
//                               iconSize: 30,
//                               style: body3L,
//                               hint: AppText.body3L(model.text),
//                               onChanged: (value) {
//                                 setState(() {
//                                   model.mybank = value;
//                                   model.addBank2();
//                                 });
//                               },
//                               items: model.listOfBank
//                                   ?.map((item) => model.buildMenuItem(
//                                       item['name'], item['code']))
//                                   .toList()),
//                         ),
//                         TextFieldWidget(
//                           color: kPrimaryColor,
//                           textColor: kPrimaryColor,
//                           hintText: 'Amount',
//                         ),
//                         const SizedBox(
//                           height: 65,
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 34.0),
//                           child: AppButton(
//                             title: 'Continue',
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//   }
// }