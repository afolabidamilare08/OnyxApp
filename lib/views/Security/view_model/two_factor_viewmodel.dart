import 'package:barcode_widget/barcode_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/models/failure.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/widgets/base_view_model.dart';

import '../../../core/constants/routeargument_key.dart';
import '../../../core/routes/routing_constants.dart';
import '../../../utils/color.dart';
import '../../../utils/locator.dart';
import '../../../utils/text.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/flushbar.dart';
import '../../../widgets/two_factor_widget.dart';

class TwoFactorViewModel extends BaseViewModel {
  NavigationService _navigationService = NavigationService.I;
  NetworkClient _networkClient = NetworkClient();
  LocalCache _localCache = locator<LocalCache>();
  TextEditingController twofaController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var secretKey;
  onNextTapped() async {
    String? userid = _localCache.getToken();
    try {
      isLoading = true;
      var response = await _networkClient
          .get('/create2fa', queryParameters: {'userid': userid});
      isLoading = false;
      secretKey=response['secret_key'];
      showModalBottomSheet(
          context: _navigationService.navigatorKey.currentContext!,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (context) {
            return Container(
              height: (MediaQuery.of(context).size.height * 2.5) / 3,
              decoration: const BoxDecoration(
                  color: kBlackColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    AppText.heading2L(
                      'Secret key',
                      centered: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AppText.body3L(
                        'Copy the secret key or scan the QR code below to your Google Authenticator app'),
                    SizedBox(
                      height: 25,
                    ),
                    // AppText.heading2L('Secret key'),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Wrap(
                      // child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FlutterClipboard.copy(response['secret_key']);
                            OnyxFlushBar.showSuccess(
                                context: context, message: 'Copied');
                          },
                          child: AppText.heading1L(
                            response['secret_key'],
                            centered: true,
                            color: kSuccessColor,
                          ),
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // IconButton(
                        //     onPressed: () {
                        //       FlutterClipboard.copy(response['secret_key']);
                        //       OnyxFlushBar.showSuccess(
                        //           context: context, message: 'Copied');
                        //     },
                        //     icon: Icon(
                        //       Icons.copy,
                        //       color: kSecondaryColor,
                        //     ))
                      ],
                    ),
                    AppText.body4L(
                      'Tap key to copy',
                      textAlign: TextAlign.right,
                    ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: BarcodeWidget(
                      barcode: Barcode.qrCode(),
                      data: response['qr_code'],
                      color: kSecondaryColor,
                    )),
                    SizedBox(
                      height: 25,
                    ),
                    AppButton(
                      title: 'Continue',
                      backgroundColor: kSecondaryColor,
                      textColor: kPrimaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            builder: (context) {
                              return TwoFactorBottomSheet(
                                formKey: formKey,
                                controller: twofaController,
                                onTap: () async {
                                  Navigator.pop(context);
                                  if (formKey.currentState!.validate()) {
                                    FocusScope.of(context).unfocus();
                                    // try {
                                    //   isLoading = true;
                                    //   var response = await _networkClient.post(
                                    //       '/verify2fa',
                                    //       body: FormData.fromMap({
                                    //         'userid': userid,
                                    //         'twofacode': twofaController.text
                                    //       }));
                                    //   isLoading = false;
                                      try {
                                        isLoading = true;
                                        var response = await _networkClient
                                            .post('/insert2fa',
                                                body: FormData.fromMap({
                                                  'userid': userid,
                                                  'twofacode':
                                                     twofaController.text,
                                                    // 'secret_key':secretKey
                                                }));
                                        isLoading = false;
                                        _navigationService.navigateTo(NavigatorRoutes.success,
            argument: {RouteArgumentkeys.heading: '2-Factor authentication set Succesfully',RouteArgumentkeys.subheading:''});
                                      } on InvalidCredentialException {
                                        OnyxFlushBar.showError(
                                            message: 'Something went wrong',
                                            title: 'Error');
                                        isLoading = false;
                                      } on Failure catch (e) {
                                        OnyxFlushBar.showError(
                                            message: e.message, title: e.title);
                                        isLoading = false;
                                      }
                                    // } on InvalidCredentialException {
                                    //   OnyxFlushBar.showError(
                                    //       message: 'Invalid code',
                                    //       title: 'Error');
                                    //   isLoading = false;
                                    // } on Failure catch (e) {
                                    //   OnyxFlushBar.showError(
                                    //       message: e.message, title: e.title);
                                    //   isLoading = false;
                                    // }
                                  }
                                },
                              );
                            });
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            );
          });
    } on Failure catch (e) {
      OnyxFlushBar.showError(message: e.message, title: e.title);
      isLoading = false;
    }
  }
}
