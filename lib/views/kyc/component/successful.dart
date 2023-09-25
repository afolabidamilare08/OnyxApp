import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/widgets/app_button.dart';

import '../../../core/routes/routing_constants.dart';

// ignore: must_be_immutable
class Successful extends StatefulWidget {
  Successful({Key? key, required this.title, this.caption, })
      : super(key: key);
  final String title;
  final String? caption;
  @override
  State<Successful> createState() => _SuccessfulState();
}

class _SuccessfulState extends State<Successful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            AppText.heading3L(widget.title),
            const SizedBox(
              height: 16,
            ),
            AppText.body3L(widget.caption ?? ""),
            SvgPicture.asset("assets/svgs/kyc_successful.svg"),
            const Spacer(),
            AppButton(
              title: "Continue",
              onTap: ()=>Navigator.popUntil(context,
                          ModalRoute.withName(NavigatorRoutes.homeView)),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
