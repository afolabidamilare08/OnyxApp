// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class NavigationService {
  NavigationService._();
  static final NavigationService _i = NavigationService._();
  static NavigationService get I => _i;
  // * Creating an Instance of the Navigation Class

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Object? argument}) async {
    return await navigatorKey.currentState!
        .pushNamed(routeName, arguments: argument);
  }

  Future<dynamic> navigateToReplace(String routeName, {Object? argument}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: argument);
  }

  ///remove all route behind
  Future<dynamic> navigateToNewRoute(String routeName, {Object? argument}) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (r) => false, arguments: argument);
  }

  Future<dynamic> navigateAndRemoveUntil(
      {required String newRoute,
      required String routeToLeave,
      Object? argument}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      newRoute,
      (r) {
        print(r.settings.name);
        return r.settings.name == routeToLeave;
      },
      arguments: argument,
    );
  }

  Future<dynamic> logOut(String routeName, {Object? argument}) {
    // navigatorKey.currentState.
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: argument);
  }

  goBack() {
    Navigator.of(navigatorKey.currentState!.context).pop();
  }
}
