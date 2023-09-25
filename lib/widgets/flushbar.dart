// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../core/services/navigation_service.dart';
import '../models/failure.dart';

class OnyxFlushBar {
  static final NavigationService _navigationService = NavigationService.I;
  static void showError(
      {required String title, required String message, int duartion = 4}) {
    Flushbar(
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: title,
      flushbarPosition: FlushbarPosition.BOTTOM,
      duration: Duration(seconds: duartion),
      isDismissible: true,
      backgroundColor: const Color(0xffF30202),
      message: message,
    ).show(_navigationService.navigatorKey.currentState!.context);
  }

  static void showFailure({
    required BuildContext context,
    required Failure failure,
    bool showTitle = true,
    Color? color,
    Duration? duration,
  }) {
    Flushbar<dynamic>(
      flushbarPosition: FlushbarPosition.BOTTOM,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: color ?? Colors.red.shade600,
      margin: const EdgeInsets.all(2),
      borderRadius: BorderRadius.circular(8),
      message: failure.message,
      title: showTitle ? failure.title : null,
    ).show(context);
  }

  /// show success indication
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    Color? color,
    Duration? duration,
  }) {
    Flushbar<dynamic>(
      flushbarPosition: FlushbarPosition.BOTTOM,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: color ?? Colors.green.shade600,
      margin: const EdgeInsets.all(2),
      borderRadius: BorderRadius.circular(8),
      message: message,
      title: title,
    ).show(context);
  }
}
