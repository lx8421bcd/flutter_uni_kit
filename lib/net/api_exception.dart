

class ApiException implements Exception {

  int code;
  String message;
  dynamic data;

  ApiException(this.code, this.message, this.data);
}