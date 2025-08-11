import 'package:dio/dio.dart';
import 'package:flutter_uni_kit/common/functions.dart';
import 'package:flutter_uni_kit/common/log.dart';
import 'package:flutter_uni_kit/net/api_exception.dart';
import 'package:flutter_uni_kit/net/api_response.dart';

/// 全局Api错误处理
typedef GlobalApiExceptionCallback = void Function(ApiException e);
/// 返回数据是否为ApiResponse检查
typedef ApiResponseCheckFunction = bool Function(dynamic data);
/// 请求是否成功检查
typedef SuccessCheckFunction = bool Function(ApiResponse response);
/// ApiResponse解析方法
typedef ApiResponseParseFunction<T> = ApiResponse<T> Function(
    Response response,
    T Function(dynamic data)? dataParseFunction
);

/// 请求成功回调，异步调用时使用
typedef OnSuccessCallback<T> = void Function(T data);
/// 请求失败回调，异步调用时使用
typedef OnFailedCallback = void Function(Exception e);

/// Api请求结果基类定义，仅用于类型判断
abstract class ApiResult<T> {}

/// Api请求成功，返回数据为非空data
class ApiResultSuccess<T> extends ApiResult<T> {
  final T data;

  ApiResultSuccess(this.data);
}

/// Api请求失败，返回错误信息
class ApiResultFailed<T> extends ApiResult<T> {
  final Exception exception;

  ApiResultFailed(this.exception);
}

///[T]需要获取的返回值类型
class ApiRequest<T> {

  static final globalApiExceptionCallbacks = <GlobalApiExceptionCallback>{};
  static ApiResponseCheckFunction defaultApiResponseCheckFunction = (dynamic data) {
    try {
      return data.containsKey("code") && data.containsKey("message");
    } catch (e) {
      return false;
    }
  };
  static ApiResponseParseFunction<T> Function<T>() defaultApiResponseParseFunction = <T>() {
    return (Response response, T Function(dynamic data)? dataParseFunction) {
      var code = response.data["code"] ?? -1;
      var message = response.data["message"] ?? "";
      var data = response.data["data"];
      return ApiResponse(
        code: code,
        message: message,
        data: data,
        dataParseFunction: dataParseFunction
      );
    };
  };
  static SuccessCheckFunction defaultRequestSuccessCheckFunction = (ApiResponse response) {
    return response.code == 0;
  };
  static Dio defaultDio = Dio();

  String url;
  Options _options = Options(method: "POST");
  Map<String, dynamic> _params = {};
  OnSuccessCallback<T>? onSuccessCallback;
  OnFailedCallback? onFailedCallback;

  Dio dio = defaultDio;
  final apiExceptionCallbacks = <GlobalApiExceptionCallback>{}..addAll(globalApiExceptionCallbacks);
  SuccessCheckFunction requestSuccessCheckFunction = defaultRequestSuccessCheckFunction;
  ApiResponseCheckFunction apiResponseCheckFunction = defaultApiResponseCheckFunction;
  ApiResponseParseFunction<T> apiResponseParseFunction = defaultApiResponseParseFunction<T>();
  T Function(dynamic data)? _dataParseFunction;
  CancelToken _cancelToken = CancelToken();


  ApiRequest(this.url);

  factory ApiRequest.get(String url) => ApiRequest(url)
    .._options = Options(method: "GET");

  factory ApiRequest.post(String url) => ApiRequest(url)
    .._options = Options(method: "POST");

  void setOptions(Options options) {
    _options = options;
  }

  void setMethod(String method) {
    _options.method = method;
  }

  void setHeaders(Map<String, dynamic> headers) {
    _options.headers = headers;
  }

  void setHeader(String key, dynamic value) {
    _options.headers ??= <String, dynamic>{};
    _options.headers?[key] = value;
  }

  void setRequestParam(String key, dynamic value) {
    _params[key] = value;
  }

  void setRequestParams(Map<String, dynamic> params) {
    _params = params;
  }

  void setDataParseFunction(T Function(dynamic data)? function) {
    _dataParseFunction = function;
  }

  void cancel() {
    _cancelToken.cancel();
  }

  Future<ApiResult<T>> execute() async {
    Exception? exception;
    T? responseData;
    try {
      do {
        if (_cancelToken.isCancelled) {
          _cancelToken = CancelToken();
        }
        // 发起请求
        Response response = await dio.request(url, data: _params, options: _options, cancelToken: _cancelToken);
        // 需求Dio Response类型返回，直接返回
        if (isSubtype<T, Response>()) {
          responseData = response as T;
          break;
        }
        // 非标准ApiResponse格式数据，按传入解析方法解析返回
        if (!apiResponseCheckFunction(response.data)) {
          responseData = _dataParseFunction?.call(response.data);
          break;
        }
        // 解析ApiResponse
        ApiResponse apiResponse = apiResponseParseFunction(response, _dataParseFunction);
        if (!requestSuccessCheckFunction(apiResponse)) {
          exception = ApiException(apiResponse.code, apiResponse.message, apiResponse.data);
          for (var callback in apiExceptionCallbacks) {
            callback.call(exception as ApiException);
          }
          break;
        }
        // 如果需求ApiResponse类型返回，则不解析，否则解析为对应类型
        responseData = isSubtype<T, ApiResponse>()
            ? apiResponse as T
            : apiResponse.parsedData;
      } while (false);
    } on Exception catch (e) {
      exception = e;
    }
    on TypeError catch (e) {
      Log.e("${e.runtimeType}\n$e\n${e.stackTrace}");
      exception = FormatException("data cast error: $e");
    }
    if (exception != null) {
      onFailedCallback?.call(exception);
      return ApiResultFailed<T>(exception);
    }
    else {
      onSuccessCallback?.call(responseData as T);
      return ApiResultSuccess<T>(responseData as T);
    }
  }

}