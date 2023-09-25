// To parse this JSON data, do
//
//     final Language = LanguageFromJson(jsonString);

import 'dart:convert';

Language languageFromJson(String str) => Language.fromJson(json.decode(str));

String languageToJson(Language data) => json.encode(data.toJson());

class Language {
  Language({
    required this.language,
  });

  String language;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "language": language,
      };
}

Country countryFromJson(String str) => Country.fromJson(json.decode(str));

String countryToJson(Country data) => json.encode(data.toJson());

class Country {
  Country({
    required this.country,
    required this.language,
  });

  String country;
  String language;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        country: json["country"],
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "language": language,
      };
}

FullName fullNameFromJson(String str) => FullName.fromJson(json.decode(str));

String fullNameToJson(FullName data) => json.encode(data.toJson());

class FullName {
  FullName({
    required this.country,
    required this.firstname,
    required this.language,
    required this.lastname,
  });

  String country;
  String firstname;
  String language;
  String lastname;

  factory FullName.fromJson(Map<String, dynamic> json) => FullName(
        country: json["country"],
        firstname: json["firstname"],
        language: json["language"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "firstname": firstname,
        "language": language,
        "lastname": lastname,
      };
}

PhoneNumberVerify phoneNumberVerifyFromJson(String str) =>
    PhoneNumberVerify.fromJson(json.decode(str));

String phoneNumberVerifyToJson(PhoneNumberVerify data) =>
    json.encode(data.toJson());

class PhoneNumberVerify {
  PhoneNumberVerify({
    required this.country,
    required this.firstname,
    required this.language,
    required this.lastname,
    required this.otpresponse,
    required this.phonenumber,
    required this.userid,
  });

  final String country;
  final String firstname;
  final String language;
  final String lastname;
  final Otpresponse otpresponse;
  final String phonenumber;
  final String userid;

  factory PhoneNumberVerify.fromJson(Map<String, dynamic> json) =>
      PhoneNumberVerify(
        country: json["country"],
        firstname: json["firstname"],
        language: json["language"],
        lastname: json["lastname"],
        otpresponse: Otpresponse.fromJson(json["otpresponse"]),
        phonenumber: json["phonenumber"],
        userid: json["userid"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "firstname": firstname,
        "language": language,
        "lastname": lastname,
        "otpresponse": otpresponse.toJson(),
        "phonenumber": phonenumber,
        "userid": userid,
      };
}

class Otpresponse {
  Otpresponse({
    required this.entity,
  });

  final List<Entity> entity;

  factory Otpresponse.fromJson(Map<String, dynamic> json) => Otpresponse(
        entity:
            List<Entity>.from(json["entity"].map((x) => Entity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "entity": List<dynamic>.from(entity.map((x) => x.toJson())),
      };
}

class Entity {
  Entity({
     this.destination,
     this.referenceId,
     this.status,
     this.statusId,
  });

  final String? destination;
  final String? referenceId;
  final String? status;
  final String ?statusId;

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
        destination: json["destination"]??'',
        referenceId: json["reference_id"]??'',
        status: json["status"].toString(),
        statusId: json["status_id"]??'',
      );

  Map<String, dynamic> toJson() => {
        "destination": destination,
        "reference_id": referenceId,
        "status": status,
        "status_id": statusId,
      };
}

PhonenumberVerification phonenumberVerificationFromJson(String str) =>
    PhonenumberVerification.fromJson(json.decode(str));

String phonenumberVerificationToJson(PhonenumberVerification data) =>
    json.encode(data.toJson());

class PhonenumberVerification {
  PhonenumberVerification({
    required this.country,
    required this.firstname,
    required this.language,
    required this.lastname,
    required this.otpresponse,
    required this.phonenumber,
    required this.phonumberverified,
    required this.userid,
    this.containsKey
  });

  final String country;
  final String firstname;
  final String language;
  final String lastname;
  final VerifyOtpresponse otpresponse;
  final String phonenumber;
  final int phonumberverified;
  final String userid;
  final String? containsKey;

  factory PhonenumberVerification.fromJson(Map<String, dynamic> json) =>
      PhonenumberVerification(
        country: json["country"],
        firstname: json["firstname"],
        language: json["language"],
        lastname: json["lastname"],
        otpresponse: VerifyOtpresponse.fromJson(json["otpresponse"]),
        phonenumber: json["phonenumber"],
        phonumberverified: json["phonumberverified"],
        userid: json["userid"],
        containsKey: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "firstname": firstname,
        "language": language,
        "lastname": lastname,
        "otpresponse": otpresponse.toJson(),
        "phonenumber": phonenumber,
        "phonumberverified": phonumberverified,
        "userid": userid,
        'error':containsKey
      };
}

class VerifyOtpresponse {
  VerifyOtpresponse({
    required this.entity,
  });

  final VerifyEntity entity;

  factory VerifyOtpresponse.fromJson(Map<String, dynamic> json) =>
      VerifyOtpresponse(
        entity: VerifyEntity.fromJson(json["entity"]),
      );

  Map<String, dynamic> toJson() => {
        "entity": entity.toJson(),
      };
}

class VerifyEntity {
  VerifyEntity({
    required this.valid,
  });

  final bool valid;

  factory VerifyEntity.fromJson(Map<String, dynamic> json) => VerifyEntity(
        valid: json["valid"],
      );

  Map<String, dynamic> toJson() => {
        "valid": valid,
      };
}
