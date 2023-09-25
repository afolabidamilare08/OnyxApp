import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/exceptions.dart';
import '../models/failure.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;
  AppInterceptors(this.dio);
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print(err.requestOptions.headers);
    print(err.requestOptions.data);
    print(err.requestOptions.uri);
    print(err.response?.data);
    print(err.response?.statusCode);

    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        // reasign err variable
        err = DeadlineExceededException(err.requestOptions);
        break;
      case DioErrorType.response:
        try {
          checkStatusCode(err.requestOptions, err.response);
        } on DioError catch (failure) {
          // reasign err variable
          err = failure;
        }

        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        log(err.message);
        err = NoInternetConnectionException(err.requestOptions);
    }
    //continue
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("Request: ${options.uri}");

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    checkStatusCode(response.requestOptions, response);
    log("Status Code : ${response.statusCode}");
    log("Response : ${response.requestOptions.uri}");
   // log('Response:${response.statusMessage}');
    log('Response:${response.data}');
    return handler.next(response);
  }

  void checkStatusCode(
      RequestOptions requestOptions, Response<dynamic>? response) {
    try {
      switch (response?.statusCode) {
        case 200:
        case 204:
        case 201:
          break;
        case 400:
          throw BadRequestException(requestOptions, response);
        case 401:
          throw UnauthorizedException(requestOptions, response);
        
        case 403:
          throw InvalidCredentialException(requestOptions, response);
        case 404:
          throw NotFoundException(requestOptions);
        case 409:
          throw ConflictException(requestOptions, response);
        case 500:
          throw InternalServerErrorException(requestOptions);
        default:
          log(response?.data.toString() ?? "");
          log(response?.statusCode.toString() ?? "");
          throw ServerCommunicationException(response);
      }
    } on Failure {
      rethrow;
    }
  }
}
