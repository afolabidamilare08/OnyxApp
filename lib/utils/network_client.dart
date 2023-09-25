import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';



import '../core/routes/api_routes.dart';
import '../models/exceptions.dart';
import '../models/failure.dart';
import '../widgets/flushbar.dart';
import 'network_interceptor.dart';

enum FormDataType { post, patch }

class NetworkClient {
  factory NetworkClient() => _singleton;

  NetworkClient._internal();

  static final NetworkClient _singleton = NetworkClient._internal();

  // late final LocalCache _localCache = locator();

  final Dio _dio = createDio();
// ======================================================
//================== Dio Initialization =================
//=======================================================
  var data;
  static Dio createDio() {
    final Dio dio = Dio(BaseOptions(
      baseUrl: ApiRoutes.baseUrl,
      receiveTimeout: 51000, // 15 seconds
      connectTimeout: 51000,
      sendTimeout: 51000,
    ));

    dio.interceptors.addAll({
      AppInterceptors(dio),
    });
    return dio;
  }

  Map<String, String> get _getAuthHeader {
    // final token = _localCache.getToken();
    // if (token != null && token.isNotEmpty) {
    //   return {
    //     "Authorization": "Bearer $token",
    //   };
    // }

    return <String, String>{};
  }

// ======================================================
//======================== Get ==========================
//=======================================================
  ///get request
  Future<T> get<T>(
    /// the api route path without the base url
    ///
    String uri, {
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    // Options options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<T> response = await _dio.get<T>(
        uri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: <String, dynamic>{
            ..._getAuthHeader,
          },
        ),
      );
/*

List y =[1,2,3,4];
List r=[0,9,8];

List p=[
...r,
...y,
];

//? value for p would be this
// p=[0.9,8,1,2,3,4];

//? assuming the queryParameterspassed is this
  // queryParameters={
  //   "q":"yola",
  //   "c":"ng",
  //   "val": "re",
  // };


    String qp = "";
    queryParameters.forEach((q){
      qp+="&q.key=q.value";
    });
    //? current value of qp
    // qp="&q=yola&c=ng&val=re";
    if(qp.isNotEmpty){
        qp="?"+ qp.subString(1,qp.length)
    }

    //? current value of qp
    // qp="?q=yola&c=ng&val=re";

      final http.Response<T> response = await http.get<T>(

        Uri.parse("${ApiRoute.baseUrl}${uri}{qp}"),
        headers: <String, dynamic>{
            ..._getAuthHeader,
          },
      );
      
       

      final result = json.decode(response.body);


      return result as T;

      */

      return response.data as T;
    } on Failure {
      rethrow;
    }
  }

// ======================================================
//======================== POST ==========================
//=======================================================
  ///Post request
  Future<T> post<T>(
    /// the api route without the base url
    String uri, {

    ///this are query parameters that would
    /// be attached to the url
    /// [e.g]=>{"a":"yes"}
    /// https://she.com/getPeople?a=yes
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? body,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<T> response = await _dio.post<T>(
        uri,
        queryParameters: queryParameters,
        data: body,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: <String, dynamic>{
            ..._getAuthHeader,
          },
        ),
      );

      log(response.statusCode.toString());
      data = jsonEncode(response.data);
      data = jsonDecode(data);
      return response.data as T;
    } 
    // on DeadlineExceededException{
    //    OnyxFlushBar.showError(
    //            title: "connection Time out",
    //            message: "Please check your internet connection and try again",
    //           );
    //      // isLoading = false;
    // }
    on Failure {
       rethrow;
    }
  }

  // Future<T> httpPost<T>(
  //   /// the api route without the base url
  //   String uri, {

  //   ///this are query parameters that would
  //   /// be attached to the url
  //   /// [e.g]=>{"a":"yes"}
  //   /// https://she.com/getPeople?a=yes
  //   Map<String, dynamic> queryParameters = const <String, dynamic>{},
  //   Object? body,
  //   CancelToken? cancelToken,
  //   ProgressCallback? onReceiveProgress,
  // }) async {
  //   try {
  //     final http.Response response =
  //         (await http.post(Uri.parse(ApiRoutes.baseUrl + uri), body: body));

  //     log(response.statusCode.toString());
  //     data = jsonDecode(response.body);
  //     return data as T;
  //   } on Failure {
  //     rethrow;
  //   }
  // }

// ======================================================
//======================== PUT ==========================
//=======================================================
  ///Put Request
  Future<T> put<T>(
    /// the api route without the base url
    String uri, {

    ///this are query parameters that would
    /// be attached to the url
    /// [e.g]=>{"a":"yes"}
    /// she.com/getPeople?a=yes
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object body = const <String, dynamic>{},
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<T> response = await _dio.put<T>(
        uri,
        queryParameters: queryParameters,
        data: body,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: <String, dynamic>{
            ..._getAuthHeader,
          },
        ),
      );
      return response.data as T;
    } on Failure {
      rethrow;
    }
  }

  Future<T> patch<T>(
    /// the api route without the base url
    String uri, {

    ///this are query parameters that would
    /// be attached to the url
    /// [e.g]=>{"a":"yes"}
    /// she.com/getPeople?a=yes
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object body = const <String, dynamic>{},
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<T> response = await _dio.patch<T>(
        uri,
        queryParameters: queryParameters,
        data: body,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: <String, dynamic>{
            ..._getAuthHeader,
          },
        ),
      );
      return response.data as T;
    } on Failure {
      rethrow;
    }
  }

// ======================================================
//======================== delete ==========================
//=======================================================
  ///get request
  Future<T> delete<T>(
    /// the api route path without the base url
    ///
    String uri, {
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    // Options options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response<T> response = await _dio.delete<T>(
        uri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(
          headers: <String, dynamic>{
            ..._getAuthHeader,
          },
        ),
      );

      return response.data as T;
    } on Failure {
      rethrow;
    }
  }

// ======================================================
//====================== Form data ======================
//=======================================================
  ///Form Data

  // Future<T> sendFormData<T>(
  //   FormDataType requestType, {

  //   /// route path without baseurl
  //   required String uri,

  //   ///this are query parameters that would
  //   /// be attached to the url
  //   /// [e.g]=>{"a":"yes"}
  //   /// she.com/getPeople?a=yes
  //   Map<String, dynamic> queryParameters = const <String, dynamic>{},

  //   /// data to be sent
  //   /// [must not add file]
  //   required Map<String, dynamic> body,

  //   /// Files to be sent
  //   /// [Files only]
  //   /// for all the images you want to send
  //   /// the key would act as the parameter sent
  //   /// to the server
  //   Map<String, File> files = const <String, File>{},
  //   CancelToken? cancelToken,
  //   ProgressCallback? onReceiveProgress,
  // }) async {
  //   try {
  //     final Map<String, MultipartFile> multipartImages =
  //         <String, MultipartFile>{};

  //     await Future.forEach<MapEntry<String, File>>(
  //       files.entries,
  //       (MapEntry<String, File> item) async {
  //         final List<String>? mimeTypeData =
  //             lookupMimeType(item.value.path, headerBytes: <int>[0xFF, 0xD8])
  //                 ?.split("/");
  //         multipartImages[item.key] = await MultipartFile.fromFile(
  //           item.value.path,
  //           contentType:
  //               http_parser.MediaType(mimeTypeData![0], mimeTypeData[1]),
  //         );
  //       },
  //     );

  //     final FormData formData = FormData.fromMap(<String, dynamic>{
  //       ...body,
  //       ...multipartImages,
  //     });
  //     Response<T> response;
  //     if (FormDataType.patch == requestType) {
  //       response = await _dio.patch<T>(
  //         uri,
  //         queryParameters: queryParameters,
  //         data: formData,
  //         cancelToken: cancelToken,
  //         onReceiveProgress: onReceiveProgress,
  //         options: Options(
  //           headers: <String, dynamic>{
  //             ..._getAuthHeader,
  //           },
  //         ),
  //       );
  //     } else {
  //       response = await _dio.post<T>(
  //         uri,
  //         queryParameters: queryParameters,
  //         data: formData,
  //         cancelToken: cancelToken,
  //         onReceiveProgress: onReceiveProgress,
  //         options: Options(
  //           headers: <String, dynamic>{
  //             ..._getAuthHeader,
  //           },
  //         ),
  //       );
  //     }

  //     return response.data as T;
  //   } on Failure {
  //     rethrow;
  //   }
  // }
}
