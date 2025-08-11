// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter_uni_kit/net/api_exception.dart';
// import 'package:flutter_uni_kit/net/api_request.dart';
// import 'package:flutter_uni_kit/net/api_response.dart';
// import 'package:flutter_uni_kit/net/http_request_info.dart';
// import 'package:flutter_uni_kit/exceptions/error_message_handler.dart';
// import 'package:flutter_uni_kit/event/event_bus.dart';
//
// class ApiConfigs {
//   ApiConfigs._internal();
//
//   static var noEncryptionList = <String>[];
//   static var doubleEncryptionList = <String>[];
//
//   static void init() {
//     // http错误信息转换
//     ErrorMessageHandler().addExceptionParser<DioException>((e) {
//       var errorResp = e.response;
//       if (errorResp != null) {
//         int code = errorResp.statusCode ?? -1;
//         return "${errorResp.statusMessage ?? "unknown"}($code)";
//       }
//       if (e.type == DioExceptionType.connectionError) {
//         var error = e.error;
//         if (error is SocketException) {
//           // dart:io内无网络状态标识
//           if (error.osError?.errorCode == 101) {
//             return AppLocalizations().errorNoNetwork;
//           }
//         }
//         return AppLocalizations().errorConnectionError;
//       }
//       if (e.type == DioExceptionType.connectionTimeout ||
//           e.type == DioExceptionType.sendTimeout
//       ) {
//         return AppLocalizations().errorTimeout;
//       }
//       return e.toString();
//     });
//     // Api错误信息转换
//     ErrorMessageHandler().addExceptionParser<ApiException>((e) {
//       if (AppConfig.debug) {
//         return "${e.message}(${e.code})";
//       }
//       return e.message;
//     });
//     // 全局Api错误处理
//     ApiRequest.globalApiExceptionCallbacks.add((e) {
//       if (e.code == ApiCodes.tokenExpired) {
//         EventBus.get().post(UserLogoutEvent());
//       }
//     });
//     // Api请求结果检查
//     ApiRequest.defaultRequestSuccessChecker = (ApiResponse response) {
//       return response.code == ApiCodes.success;
//     };
//     // Api请求默认dio配置
//     ApiRequest.defaultDio = _createApiRequestDio();
//   }
//
//   /// 用于api请求的dio对象全局配置
//   static Dio _createApiRequestDio() {
//     Dio dio = Dio();
//     var logInterceptor = HttpLogInterceptor();
//     dio.interceptors.add(HeaderInterceptors());
//     dio.interceptors.add(ParamInitInterceptor());
//     dio.interceptors.add(logInterceptor.requestInterceptor);
//     dio.interceptors.add(ApiEncryptInterceptor());
//     dio.interceptors.add(logInterceptor.responseInterceptor);
//     return dio;
//   }
//
// }