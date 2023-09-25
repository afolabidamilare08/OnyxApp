



import 'exceptions.dart';

abstract class Failure {
  String get message;

  String get title;

  bool get isInternetConnectionError =>
      runtimeType is NoInternetConnectionException;

  String? getError(error) {
    try {
      if (error is String) {
        return error;
      } else if (error is List) {
        // ? stirng : list / map
        return error[0] is String ? error[0] : error[0][0];
      }
      final item = (error as Map).values.toList()[0];
      if (item is List) {
        // ? stirng : list / map
        return item[0] is String ? item[0] : item[0][0];
      }
      return item is String ? item : null;
    } catch (e) {
      return null;
    }
  }
   String getMessagefromServer(Map<String, dynamic> error) {
    // checking the error format
    // so i can apporpriately get the error message
    // Note: input errors are different from normal error
    late String errorMessage;
    //input error test
    if (error.containsKey("errors")) {
      //get the first error model in the list then
      //the msg of the error
      errorMessage = error["errors"][0]["msg"] as String;
    }
    // normal error test
    else if (error.containsKey("message")) {
      errorMessage = error["message"] as String;
    } //default
    else {
      errorMessage = "Error";
    }
    return errorMessage;
  }
}
