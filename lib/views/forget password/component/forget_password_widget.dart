import 'package:flutter/cupertino.dart';

import 'package:onyxswap/utils/color.dart';

import 'package:onyxswap/utils/text.dart';

class ForgetPasswordWidget extends StatelessWidget {
  const ForgetPasswordWidget(
      {Key? key, required this.icon, required this.title, this.onTap})
      : super(key: key);
  final IconData icon;
  final String title;
//final String subtitle;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        height: 123,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: kBorderColor),
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 57.78,
              width: 57.78,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: kBorderColor),
              child: Center(
                  child: Icon(
                icon,
                color: kSecondaryColor,
                size: 20,
              )),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.body2L(title),
                AppText.body2L(
                  'Tap to send SMS to reset your password',
                  //multitext: true,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
