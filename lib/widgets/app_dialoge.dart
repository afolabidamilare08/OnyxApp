import 'package:flutter/material.dart';

import '../core/services/navigation_service.dart';
import '../utils/color.dart';
import '../utils/text.dart';

class AppDialog {
  static showFancyDialog({
    String? title,
    String? description,
    String? confirmationTitle,
    String? cancelTitle,
    Color? mainColor,
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: NavigationService.I.navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        backgroundColor: kPrimaryColor,
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: onConfirm,
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 120,
                      child: AppText.heading6L(confirmationTitle ?? 'Continue'),
                      decoration: BoxDecoration(
                        color: mainColor ?? kPrimaryColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 120,
                      child: AppText.heading6L(cancelTitle ?? 'Cancel'),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        title: AppText.body4L(title ?? "Title"),
        content: AppText.body1L(
          description ??
              "Reloaded 1 of 1102 libraries in 1,027ms. Reloaded 1 of 1102 libraries in 1,027ms.",
          color: kSecondaryColor,
        ),
      ),
    );
  }
}
