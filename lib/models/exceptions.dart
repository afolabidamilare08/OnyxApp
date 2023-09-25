import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'failure.dart';


class UserDefinedException extends Failure {
  final String _title;
  final String _message;

  UserDefinedException(this._title, this._message);

  @override
  String get message => _message;

  @override
  String get title => _title;
}

/// 400
class BadRequestException extends DioError with Failure {
  BadRequestException(this.request, [this.serverResponse])
      : super(requestOptions: request, response: serverResponse);
  final RequestOptions request;
  final Response? serverResponse;
  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message =>
      getError(serverResponse?.data["errors"]) ??
      serverResponse?.data["message"] ??
      "Invalid request";

  @override
  String get title => serverResponse?.data?["message"] ?? "an error occured";
}

/// 500
class InternalServerErrorException extends DioError with Failure {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message => "Unknown error occurred, please try again later.";

  @override
  String get title => "Server error";
}

/// 409
class ConflictException extends DioError with Failure {
  ConflictException(this.request, [this.serverResponse])
      : super(requestOptions: request, response: serverResponse);
  final RequestOptions request;
  final Response? serverResponse;
  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message =>
      getError(serverResponse?.data["errors"]) ?? "Conflict occurredd.";

  @override
  String get title => serverResponse?.data?["message"] ?? "Network error";
}

/// 401
class UnauthorizedException extends DioError with Failure {
  UnauthorizedException(this.request, [this.serverResponse])
      : super(requestOptions: request, response: serverResponse);
  final RequestOptions request;
  final Response? serverResponse;
  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message =>
      getError(serverResponse?.data["errors"]) ?? "Invalid request";
  @override
  String get title => serverResponse?.data?["message"] ?? "Access denied";
}

class InvalidCredentialException extends DioError with Failure {
  InvalidCredentialException(this.request, [this.serverResponse])
      : super(requestOptions: request, response: serverResponse);
  final RequestOptions request;
  final Response<dynamic>? serverResponse;
  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message =>
      ((serverResponse?.data as Map<String, dynamic>?)?["error"] as String?) ??
      "Invalid credential"; // serverResponse?.data?["message"] ?? "Invalid request";
  @override
  String get title => "Access denied";
}

/// 404
class NotFoundException extends DioError with Failure {
  NotFoundException(this.request, [this.serverResponse])
      : super(requestOptions: request, response: serverResponse);
  final RequestOptions request;
  final Response<dynamic>? serverResponse;
  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message =>
      ((serverResponse?.data as Map<String, dynamic>?)?["error"] as String?) ??
      "Resouce not found";
  // serverResponse?.data?["message"] ?? "Not Found, please try again.";

  // @override
  // String get message => "Not Found, please try again.";

  @override
  String get title => "Not Found";
}

class NotFoundExceptionhttp extends HttpException with Failure {
  NotFoundExceptionhttp(super.message);

  @override
 
  String get title => 'Not Found';
}

/// No Internet
class NoInternetConnectionException extends DioError with Failure {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message => "No internet connection, please try again.";

  @override
  String get title => "Network error";
}

/// Timeout
class DeadlineExceededException extends DioError with Failure {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message => "The connection has timed out, please try again.";

  @override
  String get title => "Network error";
}

/// errors sent back by the server in json
class ServerCommunicationException extends DioError with Failure {
  ServerCommunicationException(this.r)
      : super(requestOptions: r!.requestOptions);

  /// sustained so that the data sent by the server can be gotten to construct message
  final Response? r;

  @override
  String toString() {
    return 'title: $title message: $message';
  }

  @override
  String get message {
    log(r?.data?.toString() ?? "");
    return getError(r?.data ?? {"message": "Server Error"}) ?? "Server Error";
  }
  // eddietonsagie@gmail.com

  @override
  String get title => r?.data?["message"] ?? "Network error";
}
// austingodwin18@gmail.com