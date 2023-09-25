import 'package:dio/dio.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/utils/locator.dart';

import '../../../core/routes/api_routes.dart';
import '../../../core/routes/routing_constants.dart';
import '../../../core/services/navigation_service.dart';
import '../../../models/exceptions.dart';
import '../../../models/login_response.dart';
import '../../../utils/network_client.dart';
import '../../../views/authentication/models/signup_model.dart';
import '../../../widgets/flushbar.dart';
import 'auth_interface.dart';

class AuthRepositoryImpl implements AuthRepositiory {
  final NetworkClient _networkClient = NetworkClient();
  final NavigationService _navigationService = NavigationService.I;
  late String languages;
  late String userid;
  late String selectedCountry;
  String? firstName;
  late String lastName;
  late String phone;
  late String sentphoneotp;
  late String sentemailOtp;
  late int isPhoneVerified;
  String? sentemail;
  late String sentDob;
  late String sentPassword;
  late String isEmailVerified;
  final LocalCache _localCache = locator<LocalCache>();
  @override
  Future<Country> country(String country) async {
    final response = Country.fromJson(await _networkClient.post(
        ApiRoutes.country,
        body: FormData.fromMap({'selectcountry': country})));
    if (country != null) {
      selectedCountry = country;
      print('get');
    } else {
      print('error');
    }
    country = response.country;
    await _networkClient.get(ApiRoutes.fullname, queryParameters: {
      'language': response.language,
      'country': response.country
    });
    return response;
  }

  @override
  Future<Map<String, dynamic>> emailVerification(String emailotp) async {
    await _networkClient.get(ApiRoutes.emailverification, queryParameters: {
      'language': languages,
      'user': userid,
      'country': selectedCountry,
      'fullname': firstName,
      'nickname': lastName,
      'phonenumber': phone,
      'phonumberverified': isPhoneVerified,
      'email': sentemail,
      'dob': sentDob,
      'password': sentPassword,
      'verifyCode': sentemailOtp
    });
    await _networkClient.post(ApiRoutes.emailverification,
        body: FormData.fromMap({'verifyemail': emailotp}));
    isEmailVerified = _networkClient.data['emailVerified'];
    return <String, dynamic>{};
  }

  @override
  Future<FullName> fullName(
      {required String firstname, required String lastname}) async {
         firstName = firstname;
    lastName = lastname;
     print(lastname);
    FullName response = FullName.fromJson(await _networkClient.post(
        ApiRoutes.fullname,
        body:
            FormData.fromMap({'firstname': firstname, 'lastname': lastname})));
    //fullname = _networkClient.data['fullname'];
    //nickname =  _networkClient.data['nickname']?? '';
   
   
    //userid = _networkClient.data['userid'];
    await _networkClient.get(ApiRoutes.phonenumber, queryParameters: {
      'language': response.language,
      'country': response.country,
      'firstname': response.firstname,
      'lastname': response.lastname
    });
    return response;
  }

  @override
  Future<Map<String, dynamic>> info(
      {required String email,
      required String dob,
      required String password,
      required String fbToken}) async {
    await _networkClient.get(ApiRoutes.info, queryParameters: {
      'language': languages,
      'user': userid,
      'country': selectedCountry,
      'firstname': firstName,
      'lastname': lastName,
      'phonenumber': phone,
      'phonumberverified': isPhoneVerified
    });
    await _networkClient.post(ApiRoutes.info,
        body: FormData.fromMap(
            {'email': email, 'dob': dob, 'password': password,'deviceToken':fbToken}));
    sentemail = email;
    sentDob = dob;
    sentPassword = password;
    Map<String, dynamic> result = _networkClient.data;
    if (result['status'] == 403) {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        duration: const Duration(seconds: 10),
        failure: UserDefinedException(
          result['error'],
          'Password must contain capital letter,small letter a number and a symbol',
        ),
      );
      return result;
    } else if (result.containsKey('error')) {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "ERROR",
          "Try again",
        ),
      );
      return result;
    }
    //sentemailOtp = _networkClient.data['verifyCode'];
    return result;
  }

  @override
  Future<Language> language(String language) async {
    final response = await _networkClient.post(ApiRoutes.language,
        body: FormData.fromMap({'language': language}));
    Language finalResponse = Language.fromJson(response);
    languages = finalResponse.language;
    await _networkClient.get(ApiRoutes.country, queryParameters: {
      'language': finalResponse.language,
    });
    print(languages);

    return Language.fromJson(response);
  }

  @override
  Future phonenumber(String phoneNumber) async {
    final response = await _networkClient.post(ApiRoutes.phonenumber,
        body: FormData.fromMap({
          'phonenumber': phoneNumber,
        }));
    if (response.containsKey('error')) {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "ERROR",
          response['error'],
        ),
      );
      return response;
    } else if (response['otpresponse'].containsKey('error')) {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "ERROR",
          response['otpresponse']['error'],
        ),
      );
      return response;
    } else {
      PhoneNumberVerify result = PhoneNumberVerify.fromJson(response);
      // ignore: unrelated_type_equality_checks
      if (result.otpresponse.entity[0].status == 400) {
        OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "ERROR",
            "Something went wrong try again",
          ),
        );
        return result;
      } else {
        phone = _networkClient.data['phonenumber'];
        sentphoneotp = result.otpresponse.entity[0].referenceId!;
        print(sentphoneotp);
        userid = result.userid;
        await _networkClient.get(ApiRoutes.phoneverification, queryParameters: {
          'language': result.language,
          'user': result.userid,
          'country': result.country,
          'firstname': result.firstname,
          'lastname': result.lastname,
          'phonenumber': result.phonenumber,
          'reference_id': result.otpresponse.entity[0].referenceId
        });
        return result;
      }
    }
  }

  @override
  Future<Map<String, dynamic>> phonenumberVerification(String phoneOtp) async {
    Map<String, dynamic> response =
        await _networkClient.post(ApiRoutes.phoneverification,
            body: FormData.fromMap({
              'verifyphonenumbercode': phoneOtp,
            }));

    Map<String, dynamic> data = _networkClient.data['otpresponse'];
    if (data.containsKey('error')) {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "Error",
          "${data['error']}",
        ),
      );
      return response;
    } else {
      if (response['otpresponse']['entity']['valid'] == true) {
        isPhoneVerified = response['phonumberverified'];

        return response;
      } else {
        OnyxFlushBar.showFailure(
          context: _navigationService.navigatorKey.currentContext!,
          failure: UserDefinedException(
            "Wrong Otp",
            "Incorrect OTP",
          ),
        );
        return <String, dynamic>{'error': 'Wrong otp'};
      }
    }
  }

  @override
  Future<LoginResponse> login(
      {required String phoneNumber, required String password, required String fbToken}) async {
    Map<String, dynamic> response = await _networkClient.post(ApiRoutes.login,
        body: FormData.fromMap(
            {"phonenumber": phoneNumber, "password": password,'deviceToken':fbToken}));
    // response = _networkClient.data;
    // print(response['userid']);

    if (response.containsKey('error')) {
      OnyxFlushBar.showFailure(
        context: _navigationService.navigatorKey.currentContext!,
        failure: UserDefinedException(
          "Error",
          response['error'],
        ),
      );
      return LoginResponse.fromJson(response);
    } else {
      LoginResponse result = LoginResponse.fromJson(response);
      await _localCache.saveToken(result.userid);
      await _localCache.saveToLocalCache(
          key: 'firstname', value: result.firstname);
      await _navigationService.navigateAndRemoveUntil(
          routeToLeave: NavigatorRoutes.homeView,
          newRoute: NavigatorRoutes.homeView);
      return result;
    }
  }

  @override
  Future<Map<String, dynamic>> createPin(
      {required String pin, String? userid}) async {
    await _networkClient.post(ApiRoutes.createPin,
        body: FormData.fromMap({'pin': pin, 'userId': userid}));
    return <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> resendPhoneVerificationCode() async {
    final Map<String, dynamic> response =
        await _networkClient.post(ApiRoutes.resendPhoneVerificationcode);
    return response;
  }

  @override
  Future<Map<String, dynamic>> resendEmailVerificationCode() async {
    final Map<String, dynamic> response =
        await _networkClient.post(ApiRoutes.resendEmailVerificationcode);
    return response;
  }
}
