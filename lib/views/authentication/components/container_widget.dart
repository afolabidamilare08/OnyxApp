import 'package:flutter/material.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';
import '../../../widgets/drop_down.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget(
      {Key? key, required this.items, this.item, required this.text})
      : super(key: key);
  final List items;
  final dynamic item;
  final String text;
  @override
  Widget build(BuildContext context) {
    print(item);
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 61,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff2B3B30)),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5),
            width: 85,
            height: 44,
            decoration: BoxDecoration(
                color: kPrimaryColor, borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonHideUnderline(
                child: DropDown(
                  items: items,
                  text: item,
                  color: kSecondaryColor,
                  dropDownColor: kPrimaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          AppText.body3P(text, color: kSecondaryColor)
        ],
      ),
    );
  }
}
