import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../utils/color.dart';
import '../../../utils/text.dart';

class CardOptions extends StatelessWidget {
  const CardOptions({Key? key, required this.icon, required this.title, this.onTap}) : super(key: key);
final IconData icon;
final String title;
final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                           Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              icon,
                              color: kSecondaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppText.body3L(title),
                          const SizedBox(
                            height: 57,
                          ),
                        ],
                      ),
    );
  }
}