
import 'package:onyxswap/views/authentication/models/signup_model.dart';

import '../../../models/login_response.dart';
import '../../../utils/locator.dart';
import '../../local/local_cache/local_cache.dart';
import 'auth_interface.dart';

class AuthServiceimpl extends AuthService {
  AuthServiceimpl({
    AuthRepositiory? authRepositiory,
    LocalCache? localCache,
  })  : _authRepositiory = authRepositiory ?? locator<AuthRepositiory>(),
        _localCache = localCache ?? locator<LocalCache>();
  final AuthRepositiory _authRepositiory;
  final LocalCache? _localCache;
  @override
  Future<Country> country(String country) async {
    final Country response =
        await _authRepositiory.country(country);
    print(response);
    return response;
  }

  @override
  Future<Map<String, dynamic>> emailVerification(String emailotp) async {
    final Map<String, dynamic> response =
        await _authRepositiory.emailVerification(emailotp);
    return response;
  }

  @override
  Future<FullName> fullName(
      {required String firstname, required String lastname}) async {
    final FullName response = await _authRepositiory.fullName(
        firstname: firstname, lastname: lastname);
    return response;
  }

  @override
  Future<Map<String, dynamic>> info(
      {required String email,
      required String dob,
      required String password,
      required String fbToken
      }) async {
    final Map<String, dynamic> response =
        await _authRepositiory.info(email: email, dob: dob, password: password,fbToken: fbToken);
    return response;
  }

  @override
  Future<Language> language(String language) async {
    final Language response =
        await _authRepositiory.language(language);
    return response;
  }

  @override
  Future phonenumber(String phoneNumber) async {
    final  response =
        await _authRepositiory.phonenumber(phoneNumber);
    return response;
  }

  @override
  Future<Map<String, dynamic>> phonenumberVerification(String phoneOtp) async {
    final Map<String, dynamic> response =
        await _authRepositiory.phonenumberVerification(phoneOtp);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createPin(
      {required String pin, String? userid}) async {
    String? useridd = _localCache!.getToken();
    final Map<String, dynamic> response =
        await _authRepositiory.createPin(pin: pin, userid: userid ?? useridd);
    print(useridd);
    return response;
  }

  @override
  Future<LoginResponse> login(
      {required String phoneNumber, required String password,required String fbToken}) async {
    final LoginResponse response = await _authRepositiory.login(
        phoneNumber: phoneNumber, password: password,fbToken: fbToken);
    // save token
    // print(response['userid']);
    // await _localCache!.saveToken(response['userid']);
    // await _localCache!
    //     .saveToLocalCache(key: 'firstname', value: response['firstname']);
    // await _localCache!
    //     .saveToLocalCache(key: 'lastname', value: response.lastname);
    //save user
    // await _localCache.saveUserData(response.data!.user.toMap());

    return response;
  }

  @override
  Future<Map<String, dynamic>> resendPhoneVerificationCode() async {
    final Map<String, dynamic> response =
        await _authRepositiory.resendPhoneVerificationCode();
    return response;
  }

  @override
  Future<Map<String, dynamic>> resendEmailVerificationCode() async {
    final Map<String, dynamic> response =
        await _authRepositiory.resendEmailVerificationCode();
    return response;
  }
}
