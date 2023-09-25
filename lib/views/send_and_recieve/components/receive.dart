// ignore_for_file: avoid_unnecessary_containers

import 'package:barcode_widget/barcode_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/failure.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/account/account_view.dart';
import 'package:onyxswap/views/send_and_recieve/components/asset_button.dart';
import 'package:onyxswap/widgets/app_button.dart';
import 'package:onyxswap/widgets/flushbar.dart';

import '../../../core/routes/api_routes.dart';
import '../../../models/exceptions.dart';
import '../../../utils/custom_icons.dart';

class Receive extends StatefulWidget {
  Receive({
    Key? key,
    //required this.ontap,
    required this.title,
    //required this.selected,
    required this.data,
    // required this.selectedType
  }) : super(key: key);
  //final Function(String) ontap;
  final List<String> title;
  final String data;

  //final bool selected;
  @override
  State<Receive> createState() => _ReceiveState();
}

String text = 'BTC';
List<String> items = [
  'BTC',
  'USDT',
  'BUSD',
];
NetworkClient _networkClient = NetworkClient();
LocalCache _localCache = locator<LocalCache>();
NavigationService _navigationService = NavigationService.I;
String? address;
bool isLoading = false;

class _ReceiveState extends State<Receive> {
  onTap(int index) async {
    try {
      setState(() {
        selectedType = index == 1 ? 'USDT_TRON' : widget.title[index];
        isLoading = true;
      });
      String? userid = _localCache.getToken();
      await _networkClient.post(ApiRoutes.dashboard,
          body: FormData.fromMap({'userid': userid, 'asset': selectedType}));

      try {
        await _networkClient.post(ApiRoutes.recieve,
            body: FormData.fromMap({'userid': userid, 'asset': selectedType}));
        Map<String, dynamic> result = _networkClient.data;

        setState(() {
          address = result['address'];
          isLoading = false;
        });
      } on InternalServerErrorException {
        OnyxFlushBar.showFailure(
            context: context,
            failure: UserDefinedException(
              "Something Went wrong",
              "Please try again",
            ));
        isLoading = false;
      } on InvalidCredentialException {
        if (mounted) {
          Navigator.pop(context);
        }
        OnyxFlushBar.showFailure(
            context: _navigationService.navigatorKey.currentContext!,
            failure: UserDefinedException(
              'Error',
              'Error fetching Address',
            ));
        isLoading = false;
      } on DeadlineExceededException {
        if (mounted) {
          Navigator.pop(context);
        }
        OnyxFlushBar.showFailure(
            context: _navigationService.navigatorKey.currentContext!,
            failure: UserDefinedException(
              "connection Time out",
              "Please check your internet connection and try again",
            ));
        isLoading = false;
      } on NoInternetConnectionException {
        OnyxFlushBar.showFailure(
            context: context,
            failure: UserDefinedException(
              "No Internet connection",
              "Please check your internet connection and try again",
            ));
        isLoading = false;
      }
    } on Failure catch (e) {
      OnyxFlushBar.showError(title: e.title, message: e.message);
      isLoading = false;
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () => onTap(0));
    super.initState();
  }

  String selectedType = 'BTC';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 43,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                    3,
                    (index) => GestureDetector(
                        onTap: () => onTap(index),
                        child: AssetButtons(
                          title: widget.title[index],
                          selected: index == 1
                              ? 'USDT_TRON' == selectedType
                              : widget.title[index] == selectedType,
                        )))
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xff2f2d31)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: AspectRatio(
              aspectRatio: 375 / 389,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data: address ?? '',
                    color: kSecondaryColor,
                  )),
                  const SizedBox(
                    height: 34,
                  ),
                  AppText.body3L("Wallet Address"),
                  const SizedBox(
                    height: 7,
                  ),
                  isLoading
                      ? CircularProgressIndicator(
                          color: kPrimaryColor,
                        )
                      : AppText.body4L(address ?? ''),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 42,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(
                title: "Copy address",
                width: MediaQuery.of(context).size.width / 2.5,
                onTap: () {
                  // final data = ClipboardData(text: address);
                  //   Clipboard.setData(data);
                  FlutterClipboard.copy(address ?? '');
                  OnyxFlushBar.showSuccess(context: context, message: 'Copied');
                },
              ),
              AppButton(
                title: "Save QR code",
                width: MediaQuery.of(context).size.width / 2.5,
              )
            ],
          )
        ],
      ),
    );
  }
}
