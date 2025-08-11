/// 应用内自定义错误，用于通用错误信息提示
class LocalException implements Exception {

  final String message;

  LocalException(this.message);

  @override
  String toString() {
    return message;
  }

}