// class LoginResponse {
//   const LoginResponse({
//     required this.token,
//     required this.firstname,
//     required this.lastname,
//     // required this.user,
//   });

//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//         token: (json["userid"] ?? "") as String,
//         firstname: (json['firstname'] ?? ''),
//         lastname: (json['lastname'] ?? '')
//         // user: AuthUser.fromMap(json["user"] as Map<String, dynamic>),
//         );
//   }
//   final String token;
//   final String firstname;
//   final String lastname;
//   // final AuthUser user;
// }
import 'package:meta/meta.dart';
import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    LoginResponse({
       required this.firstname,
       required this.status,
       required this.userid,
    });

    final String firstname;
    final int status;
    final String userid;

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        firstname: json["firstname"],
        status: json["status"],
        userid: json["userid"],
    );

    Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "status": status,
        "userid": userid,
    };
}
