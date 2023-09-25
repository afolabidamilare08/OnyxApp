

import 'package:flutter/material.dart';
import '../../../utils/color.dart';
import '../../../utils/custom_icons.dart';
import '../../../utils/text.dart';

class AirtimeWidget extends StatelessWidget {
  const AirtimeWidget({Key? key, required this.children,this.onTap}) : super(key: key);
final Widget children;
final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
                    height: 69,
                    //width: double.infinity,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 31,
                            width: 31,
                            decoration: const BoxDecoration(
                                color: kPrimaryColor, shape: BoxShape.circle),
                            child: const Icon(
                              Nyxicons.airtime,
                              color: kSecondaryColor,
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          children
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}