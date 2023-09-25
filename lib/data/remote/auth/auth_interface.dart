

import 'package:onyxswap/views/authentication/models/signup_model.dart';

import '../../../models/login_response.dart';

abstract class AuthInterface {
  //late String languages;
  Future<Language> language(String language);
  // Future<Map<String, dynamic>> getLanguage();

  Future<Country> country(
    String country,
  );
  Future<FullName> fullName(
      {required String firstname, required String lastname});
  Future phonenumber(String phoneNumber);
  Future<Map<String, dynamic>> phonenumberVerification(String phoneOtp);
  Future<Map<String, dynamic>> info(
      {required String email, required String dob, required String password,required String fbToken});
  Future<Map<String, dynamic>> emailVerification(String emailotp);
  Future<LoginResponse> login(
      {required String phoneNumber, required String password,required String fbToken});
  Future<Map<String, dynamic>> createPin({required String pin, String? userid});
  Future<Map<String, dynamic>> resendPhoneVerificationCode();

  Future<Map<String, dynamic>> resendEmailVerificationCode();
}

abstract class AuthService extends AuthInterface {}

abstract class AuthRepositiory extends AuthInterface {}
