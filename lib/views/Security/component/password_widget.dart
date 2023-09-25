import 'package:flutter/cupertino.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class PasswordWidget extends StatelessWidget {
  const PasswordWidget({Key? key, required this.text,}) : super(key: key);
  final String text;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svgs/passwordcheck.svg',
            color: kSuccessColor,
          ),
          const SizedBox(
            width: 5,
          ),
          AppText.heading8N(
            text,
            color: kSecondaryColor,
          )
        ],
      ),
    );
  }
}
