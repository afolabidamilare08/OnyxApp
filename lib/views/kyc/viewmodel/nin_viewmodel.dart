import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/core/constants/routeargument_key.dart';
import 'package:onyxswap/core/routes/api_routes.dart';
import 'package:onyxswap/core/routes/routing_constants.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/views/kyc/component/kyc_bottomsheet.dart';
import 'package:onyxswap/views/kyc/component/successful.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/flushbar.dart';

import '../../../models/failure.dart';

import 'dart:convert';
import 'dart:typed_data';

class NinViewModel extends BaseViewModel {
  final NetworkClient _networkClient = NetworkClient();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LocalCache _localCache = locator<LocalCache>();
  final NavigationService _navigationService = NavigationService.I;
  bool ninvalidate = false;
  bool bvnvalidate = false;
  String? fullname;
  String? idnumber;
  String? imagetosend;
  String? ninimagetosend;

  Uint8List? image;
  Uint8List? ninimage;

  bvnValidation(
      {required String bvn,
      required BuildContext context,
      required String type}) async {
    try {
      isLoading = true;
      Map<String, dynamic> result = await _networkClient.post(
          type == 'BVN'
              ? ApiRoutes.validateBvnnumber
              : ApiRoutes.validateNinnumber,
          body: FormData.fromMap({'${type.toLowerCase()}number': bvn}));
      result = _networkClient.data;
      print(result);
      if (result['status'] == 'error') {
        OnyxFlushBar.showFailure(
            context: context,
            failure: UserDefinedException('ERROR', result['message']));
      } else if( result.containsKey('error')){
         OnyxFlushBar.showFailure(
            context: context,
            failure: UserDefinedException('ERROR', result['error']));
      }
      else {
        result = _networkClient.data['entity'];
        var blob = result[type == 'BVN' ? 'image' : 'photo'];
        imagetosend = result['image'];
        ninimagetosend = result['photo'];
        image = const Base64Codec().decode(blob);
        ninimage = const Base64Codec().decode(blob);
        fullname = result[type == 'BVN' ? 'first_name' : 'firstname'] +
            ' ' +
            result[type == 'BVN' ? 'last_name' : 'surname'];
        idnumber = result[type == 'BVN' ? 'bvn' : 'nin'];
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            builder: (context) => KycBottonsheet(
                  loading: isLoading,
                  fullname: fullname!,
                  idNumber: idnumber??'',
                  idType: type,
                  ontap: () async {
                    isLoading = true;
                    type == 'BVN'
                        ? await addBVN(
                            bvn,
                            context,
                          )
                        : await addNIN(bvn, context);
                    isLoading = false;
                  },
                  image: type == 'BVN' ? image : ninimage,
                ));
      }
      isLoading = false;
    } on Failure catch (e) {
                  OnyxFlushBar.showError(title: e.title, message: e.message);
                }
    isLoading = false;
  }

  addBVN(
    String bvn,
    BuildContext context,
  ) async {
    try {
      String? userid = _localCache.getToken();
      print(userid);
      isLoading = true;
      await _networkClient.post(ApiRoutes.insertBvn,
          body: FormData.fromMap(
              {'bvnnumber': bvn, 'userId': userid, 'image': imagetosend}));
      // print(type);
      Map<String, dynamic> result = _networkClient.data;
      if (result.containsKey('error')) {
        OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "Error",
            result['error'],
          ),
        );
        isLoading = false;
      } else {
        isLoading = false;
         _navigationService.navigateTo(NavigatorRoutes.success,
            argument: {RouteArgumentkeys.heading: 'BVN added Succesfully',RouteArgumentkeys.subheading:''});
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             Successful(title: 'BVN added Succesfully')));
      }
    } on NotFoundException {
      // print("user not found");
      OnyxFlushBar.showFailure(
        context: context,
        failure: UserDefinedException(
          "Error",
          "BVN already verified",
        ),
      );

      isLoading = false;
    }  on InvalidCredentialException {
      // print("user not found");
      OnyxFlushBar.showFailure(
        context: context,
        failure: UserDefinedException(
          "Error",
          "Error verifying BVN",
        ),
      );

      isLoading = false;
    } on Failure catch (e) {
                  OnyxFlushBar.showError(title: e.title, message: e.message);
                }
    isLoading = false;
  }

  addNIN(
    String bvn,
    BuildContext context,
  ) async {
    try {
      String? userid = _localCache.getToken();
      print(userid);
      isLoading = true;
      await _networkClient.post(ApiRoutes.insertNin,
          body: FormData.fromMap(
              {'ninnumber': bvn, 'userId': userid, 'image': ninimagetosend}));
      Map<String, dynamic> result = _networkClient.data;
      if (result.containsKey('error')) {
        OnyxFlushBar.showFailure(
          context: context,
          failure: UserDefinedException(
            "Error",
            result['error'],
          ),
        );
        isLoading = false;
      } else {
        //print(type);
        _navigationService.navigateTo(NavigatorRoutes.success,
            argument: {RouteArgumentkeys.heading: 'NIN added Succesfully',RouteArgumentkeys.subheading:''});
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             Successful(title: 'NIN added Succesfully')));
        isLoading = false;
      }
    } on NotFoundException {
      // print("user not found");
      OnyxFlushBar.showFailure(
        context: context,
        failure: UserDefinedException(
          "Error",
          "NIN already verified",
        ),
      );

      isLoading = false;
    }  on InvalidCredentialException {
      // print("user not found");
      OnyxFlushBar.showFailure(
        context: context,
        failure: UserDefinedException(
          "Error",
          "Error verifying NIN",
        ),
      );

      isLoading = false;
    } on Failure catch (failure) {
      OnyxFlushBar.showFailure(context: context, failure: failure);
      hasError = true;
      isLoading = false;
    }
  }

  test(String type, BuildContext context) async {
    String? userId = _localCache.getToken();
    Map<String, dynamic> result = await _networkClient.post(
        type == 'BVN' ? ApiRoutes.checkBvn : ApiRoutes.checkNin,
        body: FormData.fromMap({'userid': userId}));
    result = _networkClient.data;
    if (result['status'] != 200) {
      type == 'BVN' ? bvnvalidate = false : ninvalidate = false;
      notifyListeners();
    } else {
      type == 'BVN' ? bvnvalidate = true : ninvalidate = true;
      notifyListeners();
    }
  }

  checkBvn(String type, BuildContext context) async {
    try {
      isLoading = true;
      String? userId = _localCache.getToken();
      Map<String, dynamic> result = await _networkClient.post(
          type == 'BVN' ? ApiRoutes.checkBvn : ApiRoutes.checkNin,
          body: FormData.fromMap({'userid': userId}));
      result = _networkClient.data;
      if (result['status'] != 200) {
        type == 'BVN' ? bvnvalidate = false : ninvalidate = false;
        notifyListeners();
      } else {
        type == 'BVN' ? bvnvalidate = true : ninvalidate = true;
        notifyListeners();
      }
      isLoading = false;
    } on InternalServerErrorException {
//        Future.delayed(Duration.zero, () {
//   Navigator.pop(context);
// });
      OnyxFlushBar.showFailure(
        context: context,
        failure: UserDefinedException(
          "Error",
          "Error verifying $type",
        ),
      );
      isLoading = false;
      //test(type, context);
    }on Failure catch (e) {
                  OnyxFlushBar.showError(title: e.title, message: e.message);
                }
    isLoading = false;
  }
}
// showModalBottomSheet(
//         context: context,
//         builder: (context) => 
//       );
// Container(
//           height: MediaQuery.of(context).size.height / 2,
//           width: double.infinity,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   AppText.body3L(
//                     'Full Name',
//                     color: kSecondaryColor.withOpacity(0.5),
//                   ),
//                   AppText.body3L(
//                     result['first_name'] + ' ' + result['last_name'],
//                     color: kSecondaryColor,
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   AppText.body3L(
//                     'NIN number',
//                     color: kSecondaryColor.withOpacity(0.5),
//                   ),
//                   AppText.body3L(
//                     result['id_number'],
//                     color: kSecondaryColor,
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),