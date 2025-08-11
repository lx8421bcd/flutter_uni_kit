import 'package:logger/logger.dart';

/// 全局log工具
///
/// @author linxiao
/// @since 2023-10-27
class Log {
  Log._internal();

  static var debug = true;

  static final Logger _logger = Logger(
    printer: PrefixPrinter(PrettyPrinter()),
  );

  static void v(dynamic message) {
    _logger.t(message);
  }

  static void d(dynamic message) {
    _logger.d(message);
  }

  static void i(dynamic message) {
    _logger.i(message);
  }

  static void w(dynamic message) {
    _logger.w(message);
  }

  static void e(dynamic message) {
    _logger.e(message);
  }

  static void wtf(dynamic message) {
    _logger.f(message);
  }

  static void trace(dynamic message) {
    if (debug) {
      print(message.toString());
    }
  }
}
