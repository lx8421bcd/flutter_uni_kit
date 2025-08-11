class ApiResponse<T> {

  int code;
  String message;
  dynamic data;
  T Function(dynamic data)? dataParseFunction;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
    this.dataParseFunction
  });

  @override
  String toString() {
    return 'ApiResponse{code: $code, message: $message, data: $data}';
  }
  T? get parsedData => dataParseFunction?.call(data);

}