import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_uni_kit/common/log.dart';

class HttpRequestInfo {

  /* summary info */
  String method = "";
  String url = "";
  int consumedTimeMills = 0;
  /* request info */
  Map<String, dynamic>? requestHeaders;
  String requestBody = "";
  /* response info */
  int responseCode = 0;
  String responseMessage = "";
  Map<String, dynamic>? responseHeaders;
  String responseBody = "";

  void writeResponse(Response? response) {
    responseCode = response?.statusCode ?? 0;
    responseMessage = response?.statusMessage ?? "";
    responseHeaders = response?.headers.map;
    responseBody = response?.data?.toString() ?? "";
  }

  void printLog() {
    String requestHeaderStr = "";
    requestHeaders?.forEach((key, value) {
      requestHeaderStr += "$key : $value\n";
    });
    String responseHeaderStr = "";
    responseHeaders?.forEach((key, value) {
      responseHeaderStr += "$key : $value\n";
    });
    String logTemplate = """
----------------------------
url: $url
method: $method
request cost time: $consumedTimeMills ms
response code: $responseCode,  message: $responseMessage
----------request-----------
Headers:
$requestHeaderStr
Body:
$requestBody
----------response----------
Headers:
$responseHeaderStr
Body:
$responseBody
----------------------------
""";
    Log.d(logTemplate);
  }
}

class HttpLogInterceptor {

  static const _logEncoder = JsonEncoder.withIndent('  ');
  static const _keyInfoCache = "httpRequestInfo";
  static const _keyStartTime = "requestStartTime";

  QueuedInterceptorsWrapper requestInterceptor = QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        var httpRequestInfo = HttpRequestInfo();
        httpRequestInfo.url = options.uri.toString();
        httpRequestInfo.method = options.method;
        httpRequestInfo.requestHeaders = options.headers;
        try {
          httpRequestInfo.requestBody = _logEncoder.convert(options.data);
        } catch (_) {
          httpRequestInfo.requestBody = options.data.toString();
        }
        // 数据缓存至请求过程
        options.extra[_keyInfoCache] = httpRequestInfo;
        options.extra[_keyStartTime] = DateTime.now().millisecondsSinceEpoch;

        return handler.next(options);
      }
  );

  QueuedInterceptorsWrapper responseInterceptor = QueuedInterceptorsWrapper(
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      HttpRequestInfo httpRequestInfo = response.requestOptions.extra[_keyInfoCache];
      int startTime = response.requestOptions.extra[_keyStartTime];
      httpRequestInfo.consumedTimeMills = DateTime.now().millisecondsSinceEpoch - startTime;
      httpRequestInfo.writeResponse(response);
      try {
        httpRequestInfo.responseBody = _logEncoder.convert(response.data);
      } catch (e) {
        httpRequestInfo.responseBody = response.data.toString();
      }
      httpRequestInfo.printLog();
      return handler.next(response);
    },
    onError: (DioException error, ErrorInterceptorHandler handler) {
      HttpRequestInfo httpRequestInfo = error.requestOptions.extra[_keyInfoCache];
      int startTime = error.requestOptions.extra[_keyStartTime];
      httpRequestInfo.consumedTimeMills = DateTime.now().millisecondsSinceEpoch - startTime;
      httpRequestInfo.writeResponse(error.response);
      httpRequestInfo.printLog();
      return handler.next(error);
    }
  );

}