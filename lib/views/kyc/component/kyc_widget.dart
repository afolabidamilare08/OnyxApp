import 'package:flutter/material.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';

class KycWidget extends StatelessWidget {
  const KycWidget(
      {Key? key,
      required this.title,
      required this.icon,
      required this.subtitle,
      this.isverified = false,
      this.onTap})
      : super(key: key);
  final String title;
  final String subtitle;
  final IconData icon;
  final Function()? onTap;
  final bool isverified;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: kBorderColor,
            )),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor,
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        size: 21,
                        color: kSecondaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 28,
                    width: 70,
                    decoration: BoxDecoration(
                        color: isverified ? kSuccessColor : kSecondaryColor,
                        borderRadius: BorderRadius.circular(9)),
                    child: Center(
                      child: AppText.button3P(
                          isverified ? 'Verified' : 'Tier 0/2',
                          color: isverified ? Colors.white : kPrimaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              MediaQuery.of(context).size.height < 700
                  ? AppText.lato(
                      title,
                      color: kSecondaryColor,
                    )
                  : AppText.button2L(
                      title,
                      color: kSecondaryColor,
                    ),
              const Spacer(),
              MediaQuery.of(context).size.height < 700
                  ? AppText.body5L(
                      subtitle,
                      multitext: true,
                      color: kSecondaryColor,
                    )
                  : AppText.body3L(
                      subtitle,
                      multitext: true,
                      color: kSecondaryColor,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
